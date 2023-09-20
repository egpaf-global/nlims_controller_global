require 'roo'

require 'rest-client'
require 'json'

def authenticate
  url = 'localhost:3002/api/v1/auth/login'
  JSON.parse(RestClient.post(url, { username: 'administrator', password: 'kchlims', department: 'Lab Reception' }))['authorization']['token']
end

url = 'http://localhost:3000/api/v1/test_types'

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

  test_category = TestCategory.find_or_create_by(
    name: department,
    description: 'French Version'
  )

  # Iterate through rows and columns in the current worksheet
  (2..excel.last_row).each do |row|
    row_data = Hash[header.zip(excel.row(row).map(&:to_s))]

    puts 'Create Test type:'

    test_type = TestType.find_or_create_by(
      name: row_data['Examens'],
      test_category_id: test_category.id,
      description: 'French Version'
    )

    # Create of find test type specimen type
    specimen_type = SpecimenType.find_or_create_by(
      name: row_data['Types d\'échantillons'],
      description: 'French Version'
    )

    # Create testype specimen type link
    test_type_specimen = TesttypeSpecimentype.find_or_create_by(
        test_type_id: test_type.id,
        specimen_type_id: specimen_type.id
    )

    # Create testtype in MLAB
    payload = {
            "name": test_type.name,
            "short_name": test_type.name,
            "expected_turn_around_time": {
                "value": "10",
                "unit": "Minutes"
            },
            "print_device": false,
            "department_id": test_category.id,
            "specimens": [
                specimen_type.id
            ],
            "indicators": [
                {
                "name": "MM",
                "test_indicator_type": 2,
                "unit": "mm",
                "description": "test",
                "indicator_ranges": [
                    {
                    "interpretation": "Libre"
                    }
                ]
                }
            ],
            "organisms": [],
            "test_type": {
                "name": test_type.name,
                "short_name": test_type.name,
                "department_id": test_category.id,
                "print_device": false
            }
    }
    token = authenticate
    url = 'http://localhost:3002/api/v1/test_types'
    begin
      response = RestClient.post(url, payload, headers={Authorization: "Bearer #{token}"})
    rescue RestClient::ExceptionWithResponse => e
      puts "RestClient Error: #{e.message}"
    rescue StandardError => e
      # Handle any other standard Ruby exceptions
      puts "Error: #{e.message}"
    end

    debugger

     # Increment the progress indicator
    progress_indicator += 1

    # Calculate and display the progress percentage
    # progress_percentage = (progress_indicator.to_f / total_rows * 100).round(2)
    # puts "Progress: #{progress_percentage}%"
  end

  puts "\n"  # Add a separator between worksheets
end


