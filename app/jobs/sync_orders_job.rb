require 'rest-client'
class OrderSync
    include SuckerPunch::Job
    workers 1   

    $since_tr = 0
    $test_seq_tracker = 0
    $result_seq_tracker = 0
    $test_status_tracker = 0

    def perform()
      # Method code. Do some work.
      config = YAML.load_file("#{Rails.root}/config/couchdb.yml")[Rails.env]
      username = config['username']
      password = config['password']
      protocol = config['protocol']
      host = config['host']
      port = config['port']
      db_name = config['prefix'] + "_orders_" + config['suffix']

      begin
          

          res = JSON.parse(RestClient.get("#{protocol}://#{username}:#{password}@#{host}:#{port}/#{db_name}/_changes?include_docs=true&limit=20&since=#{$since_tr}"))
          counter = 0
          
          docs =  res['results']
          $since_tr = res['last_seq'] 
          
          if !docs.blank? 
            docs.each do |tr|
              tracking_number = tr['id']
              re =   Order.find_by_sql("SELECT * FROM orders WHERE id ='#{tracking_number}'")
              if re.length > 0
                
              
                Order.where(id: re[0].id).update_all({
                                                  :id => tr['id'], 
                                                  :patient_id => tr['doc']['patient_id'],
                                                  :specimen_type_id => tr['doc']['sample_type'],
                                                  :specimen_status_id => tr['doc']['specimen_status'],
                                                  :date_created => tr['doc']['date_created'],
                                                  :priority => tr['doc']['priority'],
                                                  :sample_drawn_by_id => tr['doc']['sample_collector']['id'],
                                                  :sample_drawn_by_name => tr['doc']['sample_collector']['name'],
                                                  :sample_drawn_by_phone_number => tr['doc']['sample_collector']['phone_number'],
                                                  :target_lab => tr['doc']['target_lab'],
                                                  :art_start_date => tr['doc']['art_start_date'],
                                                  :health_facility => tr['doc']['health_facility'],
                                                  :ward_id =>  tr['doc']['ward_or_location'],
                                                  :requested_by => tr['doc']['requested_by']
                                        })
              else
                
                         sq_order = Order.create(
                                                  id: tr['id'], 
                                                  patient_id: tr['doc']['patient_id'],
                                                  specimen_type_id: tr['doc']['sample_type'],
                                                  specimen_status_id: tr['doc']['specimen_status'],
                                                  date_created: tr['doc']['date_created'],
                                                  priority: tr['doc']['priority'],
                                                  sample_drawn_by_id: tr['doc']['sample_collector']['id'],
                                                  sample_drawn_by_name: tr['doc']['sample_collector']['name'],
                                                  sample_drawn_by_phone_number: tr['doc']['sample_collector']['phone_number'],
                                                  target_lab: tr['doc']['target_lab'],
                                                  art_start_date: tr['doc']['art_start_date'],
                                                  health_facility: tr['doc']['health_facility'],
                                                  ward_id:  tr['doc']['ward_or_location'],
                                                  requested_by: tr['doc']['requested_by']
                                )

               
              end

            end

          end


          
        #---------------------------------------------------------------------------


          db_name = config['prefix'] + "_test_" + config['suffix']
          test_res = JSON.parse(RestClient.get("#{protocol}://#{username}:#{password}@#{host}:#{port}/#{db_name}/_changes?include_docs=true&limit=20&since=#{$test_seq_tracker}"))

          test_docs =  test_res['results']
          $test_seq_tracker = test_res['last_seq']

          if !test_docs.blank?
              test_docs.each do |tst|
                doc_id = tst['id']
                  r  = Test.find_by_sql("SELECT * FROM tests WHERE tests.doc_id='#{doc_id}'")
                  if r.length > 0 
                    Test.where(id: r[0].id).update_all({
                                          :order_id => tst['doc']['order_id'],
                                          :test_type_id =>  tst['doc']['test_type_id'],
                                          :test_status_id => tst['doc']['test_status_id'],
                                          :time_created => tst['doc']['time_created'],
                                          :doc_id => doc_id,
                                    })              
                  else
                    Test.create(
                          :order_id => tst['doc']['order_id'],
                          :test_type_id =>  tst['doc']['test_type_id'],
                          :test_status_id => tst['doc']['test_status_id'],
                          :time_created => tst['doc']['time_created'],
                          :doc_id => doc_id,
                      )

                  end 
               
              end
          end






        #----------------------------------------------------------------------------
          db_name = config['prefix'] + "_test_results_" + config['suffix']
          result_res = JSON.parse(RestClient.get("#{protocol}://#{username}:#{password}@#{host}:#{port}/#{db_name}/_changes?include_docs=true&limit=20&since=#{$result_seq_tracker}"))

          result_docs =  result_res['results']
          $result_seq_tracker = result_res['last_seq']

          if !result_docs.blank?
              result_docs .each do |tst|
                doc_id = tst['id']
                  r  = TestResult.find_by_sql("SELECT * FROM test_results WHERE test_results.doc_id='#{doc_id}'")
                  if r.length > 0 
                    TestResult.where(id: r[0].id).update_all({
                                          :test_id => tst['doc']['test_id'],
                                          :measure_id =>  tst['doc']['measure_id'],
                                          :result => tst['doc']['result'],
                                          :doc_id => doc_id,
                                    })   

                               
                  else
                    TestResult.create(
                            :test_id => tst['doc']['test_id'],
                            :measure_id =>  tst['doc']['measure_id'],
                            :result => tst['doc']['result'],
                            :doc_id => doc_id,
                      )
                   
                  end 
               
              end
          end
         







          #----------------------------------------------------------------------------
          db_name = config['prefix'] + "_test_statues_" + config['suffix']
          test_status_res = JSON.parse(RestClient.get("#{protocol}://#{username}:#{password}@#{host}:#{port}/#{db_name}/_changes?include_docs=true&limit=20&since=#{$test_status_tracker}"))

          status_docs =  test_status_res ['results']
          $test_status_tracker = test_status_res ['last_seq']

          if !status_docs.blank?
            status_docs  .each do |tst|
              doc_id = tst['id']
                r  = TestStatusUpdate.find_by_sql("SELECT * FROM test_status_updates WHERE test_status_updates.doc_id='#{doc_id}'")
                if r.length > 0 
                  TestStatusUpdate.where(id: r[0].id).update_all({
                                        :test_id => tst['doc']['test_id'],
                                        :test_status_id =>  tst['doc']['test_status_id'],
                                        :time_updated => tst['doc']['time_updated'],
                                        :who_updated_id => tst['doc']['who_updated_id'],
                                        :who_updated_name => tst['doc']['who_updated_name'],                                      
                                        :doc_id => doc_id,
                                  })   

                           
                else
                  TestStatusUpdate.create(
                                        :test_id => tst['doc']['test_id'],
                                        :test_status_id =>  tst['doc']['test_status_id'],
                                        :time_updated => tst['doc']['time_updated'],
                                        :who_updated_id => tst['doc']['who_updated_id'],
                                        :who_updated_name => tst['doc']['who_updated_name'],                                      
                                        :doc_id => doc_id,
                    )
                
                end 
             
            end
          end

   
          OrderSync.perform_in(2)
      rescue
          OrderSync.perform_in(2)
      end

    end

end