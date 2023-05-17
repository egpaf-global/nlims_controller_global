namespace :master_nlims do
    desc "TODO"
    task sync_data: :environment do
      
      

      config = YAML.load_file("#{Rails.root}/config/master_nlims.yml")
      username = config['username']
      password = config['password']
      protocol = config['protocol']
      port = config['port']
   
     
      res = Test.find_by_sql("SELECT specimen.tracking_number as tracking_number, specimen.id as specimen_id,
                      tests.id as test_id,test_type_id as test_type_id, test_types.name as test_name
                      FROM tests INNER JOIN specimen ON specimen.id = tests.specimen_id 
                      INNER JOIN test_types ON test_types.id = tests.test_type_id
                      WHERE tests.id NOT IN (SELECT test_id FROM test_results) AND substr(specimen.date_created,1,10) > '2023-05-08'")

      if !res.blank?        
        auth = JSON.parse(RestClient.get("#{protocol}:#{port}/api/v1/re_authenticate/#{username}/#{password}"))       
        if auth['error'] == false
          token = auth['data']['token']
          headers = {
            content_type: 'application/json',
            token: token
          }

          res.each do |sample|
            tracking_number = sample['tracking_number']
            test_name = sample['test_name']
            test_id = sample['test_id']

  
            url = "#{protocol}:#{port}/api/v2/query_order_by_tracking_number/#{tracking_number}?test_name=#{test_name}"
            order = JSON.parse(RestClient.get(url,headers)) 
            
            if order['error'] == false              
              specimen_status = order['data']['other']['specimen_status']
              tests = order['data']['tests']
              
              tests.each do |test,details|
              
                status = details['status']
                updater_name = details['update_details']['updater_name']
                updater_id = details['update_details']['updater_id']
                time_updated = details['update_details']['time_updated']
                trail_staus =  details['update_details']['status']
                
              end


              if !order['data']['other']['results'].blank?
                results = order['data']['other']['results']
                
                results.each do |key,result|  
                  if TestType.find_by(:name => key)['id'] == sample['test_type_id']
                    result.each do |act_rst|
                      measure = act_rst[0]
                      measure_id = Measure.find_by(:name => measure)['id']
                      re_value = act_rst[1]
                      tst_save =  TestResult.create(
                                  test_id: test_id,
                                  measure_id: measure_id,
                                  result: re_value['result'],
                                  time_entered: re_value['result_date']
                                )
                      tst_save.save
                      acknwoledge_result_at_facility_level(tracking_number,test_id,re_value['result_date'])
                      puts "result updated = " + tracking_number
                    end
                  end
                end
              end
             
              tests.each do |test, details|
                test_name = test

                status = details['status']
                if !details['update_details'].blank?
                  updater_name = details['update_details']['updater_name']
                  updater_id = details['update_details']['updater_id']
                  time_updated = details['update_details']['time_updated']
                  trail_staus =  details['update_details']['status']
                end

                test_status = status
                test_status = "test-rejected"  if test_status == "rejected"
		tst_id = TestType.find_by(:name => test_name)['id']
                tst_status_id = TestStatus.find_by(:name => test_status)['id']
                
                if already_updated_with_such?(test_id,tst_status_id) == false
                  tst_update = Test.find_by(:id => test_id,:test_type_id => tst_id)
                  tst_update.test_status_id = tst_status_id
                  tst_update.save()
                  
                  if status == trail_staus
                    TestStatusTrail.create(
                      test_id: test_id,
                      time_updated: time_updated, # updated at Test.where()
                      test_status_id: tst_status_id,
                      who_updated_id:  updater_id.to_s,
                      who_updated_name: updater_name.to_s,
                      who_updated_phone_number: ""		       
                    )
                  end
                  puts "status updated = " + tracking_number
                else
                  puts "status already updated with such = " + tracking_number
                end
                
              end
            end            
          end
        end
      end

      #pushing result acknowledgment at facility level
      push_acknwoledgement_to_master_nlims()
    end
end


def already_updated_with_such?(test_id, test_status)
    res = Test.find_by(:id => test_id, :test_status_id => test_status)   
    if res == nil
      return false
    else
      return true
    end    
end


def push_acknwoledgement_to_master_nlims()
  config = YAML.load_file("#{Rails.root}/config/master_nlims.yml")
  username = config['username']
  password = config['password']
  protocol = config['protocol']
  port = config['port']
  
  res = ResultsAcknwoledge.find_by_sql("SELECT * FROM results_acknwoledges WHERE acknwoledged_to_nlims ='false'")
  
  if !res.blank?
    res.each do |order|      
        dt = Test.find_by_sql("SELECT test_types.name AS test_name
                        FROM tests 
                        INNER JOIN test_types ON test_types.id = tests.test_type_id 
                        WHERE tests.id='#{order['test_id']}'
                      ")
        level =  TestResultRecepientType.find_by(:id => order['acknwoledment_level'])
               
        if !level.blank?
          level = level['name']
        end
        data = {  
          'tracking_number': order['tracking_number'],
          'test': dt[0]['test_name'],
          'date_acknowledged': order['acknwoledged_at'],
          'recipient_type': level,
          'acknwoledment_by': order['acknwoledged_by']
        }       

        auth = JSON.parse(RestClient.get("#{protocol}:#{port}/api/v1/re_authenticate/#{username}/#{password}"))       
        if auth['error'] == false
          token = auth['data']['token']
          headers = {
            content_type: 'application/json',
            token: token
          }
          url = "#{protocol}:#{port}/api/v1/acknowledge/test/results/recipient"
          order_res = JSON.parse(RestClient.post(url,data.to_json,headers))         
          if order_res['error'] == false  
            ackn = ResultsAcknwoledge.find_by(:id => order['id'])
            ackn.acknwoledged_to_nlims = true
            ackn.save()

          end
        end
    end
  end
   
end

def acknwoledge_result_at_facility_level(tracking_number, test_id, result_date)
  check = ResultsAcknwoledge.find_by(:tracking_number => tracking_number, :acknwoledged_to_nlims => "local_nlims_at_facility")
  if check.blank?
    tr = ResultsAcknwoledge.create(
        tracking_number: tracking_number,
        test_id: test_id,
        acknwoledged_at:  Time.new.strftime("%Y%m%d%H%M%S"),
        result_date: result_date,
        acknwoledged_by: "local_nlims_at_facility",
        acknwoledged_to_nlims: false,
        acknwoledment_level: 3
      )
    tr.save
      test = Test.find_by(:id => test_id)
      test.result_given = 0,
      test.date_result_given = Time.new.strftime("%Y%m%d%H%M%S"),
      test.test_result_receipent_types = 3
      test.save
  end
end
