require 'rest-client'
class SomeWorker
    include SuckerPunch::Job
    workers 1   

    $since_tr = 1
    def perform()
      # Method code. Do some work.
     
      begin
          
          res = JSON.parse(RestClient.get("http://gibo:amin9090!@localhost:5984/nlims_orders_repo/_changes?include_docs=true&limit=20&since=#{$since_tr}"))
          counter = 0
          
          docs =  res['results']
          $since_tr = res['last_seq']

          docs.each do |tr|
            tracking_number = tr['doc']['tracking_number']
            re =   Order.find_by_sql("SELECT * FROM orders WHERE tracking_number='#{tracking_number}'")
            if re.length > 0
              puts 'yes'
            
              Order.where(id: re[0].id).update_all({
                                                :doc_id => tr['id'], 
                                                :tracking_number => tracking_number,
                                                :patient_id => '11',
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
                                                doc_id: tr['id'], 
                                                tracking_number: tracking_number,
                                                patient_id: '11',
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

              puts 'not'
            end

          end
        

   
          SomeWorker.perform_in(2)
      rescue
          SomeWorker.perform_in(2)
      end

    end

end