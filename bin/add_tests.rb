require 'roo'
require 'rest-client'
require 'json'
require 'uri'

DEPARTMENT_TRANSLATION = {
  'Hématologie' => 'Haematology',
  'Immuno hématologie' => 'Immunochemistry',
  'Biochimie' => 'Biochemistry',
  'Parasitologie' => 'Parasitology',
  'Sérologie' => 'Serology'
}.freeze


print 'Please enter the url mlab is running on including port (eg: localhost:3002): '
url = gets.chomp 
URL = "http://#{url}/api/v1/".freeze
http_method = :get
url = 'departments'
payload = {}
print 'Please enter MLAB Administrator password: '
@mlab_password = gets.chomp

def authenticate
  token = ''

  loop do
    break unless token.blank?

    url = "#{URL}/auth/login"
    begin
      response = RestClient.post(url,
                                 { username: 'administrator', password: @mlab_password,
                                   department: 'Lab Reception' })
      token = JSON.parse(response)['authorization']['token']
    rescue RestClient::ExceptionWithResponse => e
      if JSON.parse(e.response.body)['error'] == 'Invalid username or password'
        print 'You provided an invalid password. Please re-enter: '
        @mlab_password = gets.chomp
      end
    end
  end
  token  # Return the obtained token
end


def mlab_request(http_method, url, payload)
  token = authenticate
  url = "#{URL}#{url}"

  begin
    response = RestClient::Request.execute(method: http_method, url: url, payload: payload,
                                           headers: { content_type: :json, accept: :json,
                                                      Authorization: "Bearer #{token}" })
    pursed_response = JSON.parse(response)
  rescue RestClient::ExceptionWithResponse => e
    return 'test exists' if JSON.parse(e.response.body)['error'] == 'Validation failed: Name has already been taken'

    error_message = "RestClient Error: #{e.message}"
    response_body = e.response.body
    raise "#{error_message}\nResponse Body: #{response_body}"
  rescue StandardError => e
    # Handle any other standard Ruby exceptions
    raise "Error: #{e.message}"
  end
end

MLAB_DEPARTMENTS = mlab_request(http_method, url, payload)
url = 'specimen'
MLAB_SPECIMEN_TYPES = mlab_request(http_method, url, payload)
url = 'test_types/test_indicator_types/'
MLAB_TEST_INDICATOR_TYPES = mlab_request(http_method, url, payload)

def department_english_name(department)
  DEPARTMENT_TRANSLATION[department]
end

def test_indicator_type_id(type)
  if type.blank?
    type = 'Free Text'
  else
    case type
    when Float
      type = 'numeric'
    when Integer
      type = 'numeric'
    when String
      type = 'Auto complete'
    end
  end
  (MLAB_TEST_INDICATOR_TYPES.find { |indicator| indicator['name'] == type })['id'] rescue 1
end
# Specify the path to your Excel file
excel_file_path = "#{Rails.root}/storage/EXAMENS.xlsx"

# Create a Roo Excel object
excel = Roo::Excelx.new(excel_file_path)

header = excel.row(1).map(&:to_s)

total_rows = excel.last_row - 1 # Subtract 1 to exclude the header row

# Initialize a progress indicator
progress_indicator = 0

# Iterate through each worksheet (tab) in the Excel file
excel.sheets.each do |department|
  # Use the sheet method to select the current worksheet
  excel.default_sheet = department

  puts "Data from sheet: #{department}"

  puts 'Create Test Category'

  lims_department_name = department_english_name(department)
  mlab_department_id = (MLAB_DEPARTMENTS.find do |mlab_department|
                          mlab_department['name'] == lims_department_name
                        end)['id']

  test_category = TestCategory.find_or_create_by!(
    name: lims_department_name
  )

  # Iterate through rows and columns in the current worksheet
  (2..excel.last_row).each do |row|
    row_data = Hash[header.zip(excel.row(row).map(&:to_s))]

    puts "Creating Test type: #{row_data['Examens']}"

    test_type = TestType.find_by_name(row_data['Examens'])
    if test_type.blank?
      test_type = TestType.create!(
        name: row_data['Examens'],
        test_category_id: test_category.id,
        description: 'French Version'
      )
    end
    specimen_names = (row_data['Types d\'échantillons'] = 'Blood/Serum/Plasma').split('/')
    specimen_type = SpecimenType.where(name: specimen_names)

    specimen_type.each do |specimen|
      next if specimen_names.include?(specimen.name)

      # Create or find test type specimen type
      specimen_type << SpecimenType.create!(
        name: row_data['Types d\'échantillons'],
        description: 'French Version'
      )
      # Create testype specimen type link
      TesttypeSpecimentype.find_or_create_by(
        test_type_id: test_type.id,
        specimen_type_id: specimen_type.id
      )
    end

    # Create measure 
    Measure.find_or_create_by(
      name: row_data['Examens'],
      measure_type_id: MeasureType.find_by_name(row_data['measure type']).id
    )

    
    # Create testtype in MLAB
    http_method = :post
    url = 'test_types'
    mlab_specimen_type_ids = specimen_type.map do |specimen_name|
      (MLAB_SPECIMEN_TYPES.find { |specimen| specimen['name'] == specimen_name.name })['id']
    end
    
    mlab_indicator_type_id = test_indicator_type_id(row_data['Résultats'])
    unit = row_data['Unités']
    lower_range = row_data['Low band']
    upper_range = row_data['Upper band']
    gender = (case row_data['gender']
              when 'H'
                'Male'
              when 'F'
                'Female'
              end)

    payload = {
      "name": test_type.name,
      "short_name": test_type.name,
      "expected_turn_around_time": {
        "value": '10',
        "unit": 'minutes',
      },
      "print_device": false,
      "department_id": mlab_department_id,
      "specimens": mlab_specimen_type_ids,
      "indicators": [
        {
          "name": test_type.name,
          "test_indicator_type": mlab_indicator_type_id,
          "unit": unit,
          "description": ''
        }
      ],
      "organisms": [],
      "test_type": {
        "name": test_type.name,
        "short_name": test_type.name,
        "department_id": mlab_department_id,
        "print_device": false
      }
    }
    
    if row_data['measure type'] == 'Numeric Range'
      payload[:indicators][0][:indicator_ranges] = [{
            "min_age": 0,
            "max_age": 120,
            "sex": gender,
            "lower_range": lower_range,
            "upper_range": upper_range
          }]
    end
      

    payload = payload.to_json
    # Create test in MLAB
    response = mlab_request(http_method, url, payload)
    if response == 'test exists'

      puts "#{response} update test "
      escaped_test_type = URI.escape(test_type.name)
      fetch_url = "test_types?search=#{escaped_test_type}"
      http_method = 'GET'
      mlab_test_type = mlab_request(http_method, fetch_url, payload)['test_types'].find do |test|
        test['name'] == test_type.name
      end
      fetch_url = "test_types/#{mlab_test_type['id']}" rescue next
      payload = {}
      begin
        mlab_editable_test_type = mlab_request(http_method, fetch_url, payload)
      rescue
        
      end
      
      if row_data['measure type'] == 'Numeric Range'
         mlab_indicator_type_id = {id: 2, name: 'Numeric'}
      else
         mlab_indicator_type_id = {id: 1, name: 'Free Text'}
      end
      
      mlab_editable_test_type['indicators'][0]['test_indicator_type'] = mlab_indicator_type_id
      # update_payload = { specimens: mlab_specimen_type_ids,
      #             organisms: [],
      #             "test_type": mlab_test_type,
      #             expected_turn_around_time: mlab_test_type['expected_turn_around_time'],
      #             "indicators": [
      #               {
      #                 "name": test_type.name,
      #                 "test_indicator_type": mlab_indicator_type_id,
      #                 "unit": unit,
      #                 "description": ''
      #               }
      #             ] }
    
      if row_data['measure type'] == 'Numeric Range'
        begin
          mlab_editable_test_type['indicators'][0]['indicator_ranges'][0]['sex'] = gender
          mlab_editable_test_type['indicators'][0]['indicator_ranges'][0]['lower_range'] = lower_range
          mlab_editable_test_type['indicators'][0]['indicator_ranges'][0]['upper_range'] = upper_range
        rescue
          next 
        end
        # update_payload[:indicators][0][:indicator_ranges] = [{
        #       "min_age": 0,
        #       "max_age": 120,
        #       "sex": gender,
        #       "lower_range": lower_range,
        #       "upper_range": upper_range
        #     }]
      end

      update_payload = mlab_editable_test_type.to_json
      http_method = 'PUT'
      update_url = "#{url}/#{mlab_test_type['id'].to_s}"
      
      response = mlab_request(http_method, update_url, update_payload)
    end
  end

  puts "\n"  # Add a separator between worksheets
end