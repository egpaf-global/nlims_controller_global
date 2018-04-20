require 'rest-client'
class SampleStatistics
    include SuckerPunch::Job
    workers 1   

    def perform()
      # Method code. Do some work.
      
      begin   
        config = YAML.load_file("#{Rails.root}/config/application.yml")
        site_name = config['facility_name']
        data = {}
        tests = []

        orders = Order.find_by_sql("SELECT * FROM orders WHERE health_facility='#{site_name}' AND date_dispatched IS NULL")
        undisp = []
        details = []
        orders.each do |order|
        
            status_id = order.specimen_status_id
            specimen_type_id = order.specimen_type_id
            tracking = order.id
            npid = order.patient_id
            date_created = order.date_created
            priority = order.priority
            target_lab = order.target_lab

            status = SpecimenStatus.where(id: status_id).first
            specimen_name = SpecimenType.where(id: specimen_type_id).first

            tsts = Test.find_by_sql("SELECT test_types.name AS tst_name FROM test_types 
                                    INNER JOIN tests ON tests.test_type_id = test_types.id
                                    INNER JOIN orders ON orders.id = tests.order_id 
                                    WHERE orders.id='#{tracking}'
                                    ")

            if tsts.length > 0
              tsts.each do |tt|
                tests.push(tt.tst_name)
              end
            end

            specimen_name = specimen_name.name
            status = status.name
            details = {
                        'specimen_name' => specimen_name,
                        'specimen_status' => status,
                        'npid' => npid,
                        'priority' => priority,
                        'target_lab' => target_lab,
                        'date_created' => date_created,
                        'tracking_number' => tracking,
                        'tests' => tests
            }

            undisp.push(details) 
            tests = []

        end         
        data['undispatched_samples'] = undisp


        

        #----------------------------------------------------------------------------------------

        stat_id = SpecimenStatus.where(name: 'specimen_rejected').first
        orders = Order.find_by_sql("SELECT * FROM orders WHERE health_facility='#{site_name}' AND specimen_status_id='#{stat_id.id}'")
        reject = []
        re_details = []
        orders.each do |order|
           
            specimen_type_id = order.specimen_type_id
            tracking = order.id
            npid = order.patient_id
            date_created = order.date_created
            priority = order.priority
            target_lab = order.target_lab

            specimen_name = SpecimenType.where(id: specimen_type_id).first
            specimen_name = specimen_name.name
            status = stat_id.name
            
            tsts = Test.find_by_sql("SELECT test_types.name AS tst_name FROM test_types 
                                    INNER JOIN tests ON tests.test_type_id = test_types.id
                                    INNER JOIN orders ON orders.id = tests.order_id 
                                    WHERE orders.id='#{tracking}'
                                    ")

            if tsts.length > 0
              tsts.each do |tt|
                tests.push(tt.tst_name)
              end
            end

            re_details = {
                        'specimen_name' => specimen_name,
                        'specimen_status' => status,
                        'npid' => npid,
                        'priority' => priority,
                        'target_lab' => target_lab,
                        'date_created' => date_created,
                        'tracking_number' => tracking,
                        'tests' => tests
            }

            reject.push(re_details) 
            tests = []
        end 
        tests = []
        data['rejected_samples'] = reject



        #----------------------------------------------------------------------------------------

        File.open("#{Rails.root}/public/sample_statistics.json",'w') { |f|
          f.write(data.to_json)
        }
        SampleStatistics.perform_in(2)
      
      rescue
        SampleStatistics.perform_in(2)
      end

    end

end