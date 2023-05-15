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
                      WHERE tests.id NOT IN (SELECT test_id FROM test_results) AND substr(specimen.date_created,1,10) > '2023-04-19'")

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
                      puts "result updated = " + tracking_number
                    end
                  end
                end
              end
             
              tests.each do |test, status|
                test_name = test
                test_status = status
                tst_id = TestType.find_by(:name => test_name)['id']
                tst_status_id = TestStatus.find_by(:name => test_status)['id']

                tst_update = Test.find_by(:id => test_id,:test_type_id => tst_id)
                tst_update.test_status_id = tst_status_id
                tst_update.save()
                puts "status updated = " + tracking_number
              end
            end            
          end
        end
      end
    end
end


def create_order()
  
end