
module  OrderService

      def self.create_order(params,tracking_number)
            couch_order = 0
            ActiveRecord::Base.transaction do 

                  npid = params[:national_patient_id]
                  patient_obj = Patient.where(:patient_number => npid)
                
                  patient_obj = patient_obj.first unless patient_obj.blank?

                        if patient_obj.blank?
                              patient_obj = patient_obj.create(
                                                patient_number: npid,
                                                name: params[:first_name] +" "+ params[:last_name],
                                                email: '' ,
                                                dob: params[:date_of_birth],
                                                gender: params[:gender],
                                                phone_number: params[:phone_number],
                                                address: "",
                                                external_patient_number:  "" 

                                                )
                                 
                        end

                                    
                  who_order = {
                        :first_name => params[:who_order_test_first_name],
                        :last_name => params[:who_order_test_last_name],
                        :phone_number => params[:who_order_test_phone_number],
                        :id => params[:who_order_test_id]
                  }

                  patient = {
                        :first_name => params[:first_name],
                        :last_name => params[:last_name],
                        :phone_number => params[:phone_number],
                        :id => npid,
                        :email => params[:email],
                        :gender => params[:gender] 
                  }
                  sample_status =  {}
                  test_status = {}
                  time = Time.now.strftime("%Y%m%d%H%M%S") if params[:date_sample_drawn].blank? 
                  time = params[:date_sample_drawn] if !params[:date_sample_drawn].blank?
                  sample_status[time] = {
                        "status" => "Drawn",
                              "updated_by":  {
                                    :first_name => params[:who_order_test_first_name],
                                    :last_name => params[:who_order_test_last_name],
                                    :phone_number => params[:who_order_test_phone_number],
                                    :id => params[:who_order_test_id] 
                                    }
                  }

                  sample_type_id = SpecimenType.get_specimen_type_id(params[:sample_type])
                  sample_status_id = SpecimenStatus.get_specimen_status_id(params[:sample_status])
                 
      
            sp_obj =  Speciman.create(
                        :tracking_number => tracking_number,
                        :specimen_type_id =>  sample_type_id,
                        :specimen_status_id =>  sample_status_id,
                        :couch_id => '',
                        :ward_id => Ward.get_ward_id(params[:order_location]),
                        :priority => params[:sample_priority],
                        :drawn_by_id => params[:who_order_test_id],
                        :drawn_by_name =>  params[:who_order_test_first_name] + " " + params[:who_order_test_last_name],
                        :drawn_by_phone_number => params[:who_order_test_phone_number],
                        :target_lab => params[:target_lab],
                        :art_start_date => Time.now,
                        :sending_facility => params[:health_facility_name],
                        :requested_by =>  params[:requesting_clinician],
                        :district => params[:district],
                        :date_created => params[:date_sample_drawn]
                  )

                  
                        res = Visit.create(
                                 :patient_id => npid,
                                 :visit_type_id => '',
                                 :ward_id => Ward.get_ward_id(params[:order_location])
                              )
                        visit_id = res.id

                  params[:tests].each do |tst|
                        tst = tst.gsub("&amp;",'&')
                        status = check_test(tst)
                        if status == false
                              details = {}
                              details[time] = {
                                    "status" => "Drawn",
                                    "updated_by":  {
                                          :first_name => params[:who_order_test_first_name],
                                          :last_name => params[:who_order_test_last_name],
                                          :phone_number => params[:who_order_test_phone_number],
                                          :id => params[:who_order_test_id] 
                                          }
                              }
                              test_status[tst] = details                  
                              rst = TestType.get_test_type_id(tst)
                              rst2 = TestStatus.get_test_status_id('drawn')

                              Test.create(
                                    :specimen_id => sp_obj.id,
                                    :test_type_id => rst,
                                    :patient_id => patient_obj.id,
                                    :created_by => params[:who_order_test_first_name] + " " + params[:who_order_test_last_name],
                                    :panel_id => '',
                                    :time_created => time,
                                    :test_status_id => rst2
                              )
                        else
                              pa_id = PanelType.where(name: tst).first
                              res = TestType.find_by_sql("SELECT test_types.id FROM test_types INNER JOIN panels 
                                                            ON panels.test_type_id = test_types.id
                                                            INNER JOIN panel_types ON panel_types.id = panels.panel_type_id
                                                            WHERE panel_types.id ='#{pa_id.id}'")
                              res.each do |tt|
                                    details = {}
                                    details[time] = {
                                          "status" => "Drawn",
                                          "updated_by":  {
                                                :first_name => params[:who_order_test_first_name],
                                                :last_name => params[:who_order_test_last_name],
                                                :phone_number => params[:who_order_test_phone_number],
                                                :id => params[:who_order_test_id] 
                                                }
                                    }
                                    test_status[tst] = details                  
                                    #rst = TestType.get_test_type_id(tt)
                                    rst2 = TestStatus.get_test_status_id('drawn')
                                    Test.create(
                                          :specimen_id => sp_obj.id,
                                          :test_type_id => tt.id,
                                          :patient_id => patient_obj.id,
                                          :created_by => params[:who_order_test_first_name] + " " + params[:who_order_test_last_name],
                                          :panel_id => '',
                                          :time_created => time,
                                          :test_status_id => rst2
                                    )
                              end
                        end
                  end
                  
                  couch_tests = {}
                  params[:tests].each do |tst|
                        couch_tests[tst] = {
                              'results': {},
                              'date_result_entered': '',
                              'result_entered_by': {}                             
                        }
                  end

            c_order  =  Order.create(
                        tracking_number: tracking_number,
                        sample_type: params[:sample_type],
                        date_created: params[:date_sample_drawn],
                        sending_facility: params[:health_facility_name],
                        receiving_facility: params[:target_lab],
                        tests: params[:tests],
                        test_results: couch_tests,
                        patient: patient,
                        order_location: params[:order_location] ,
                        districy: params[:district],
                        priority: params[:sample_priority],
                        who_order_test: who_order,
                        sample_statuses: sample_status,
                        test_statuses: test_status,
                        sample_status: params[:sample_status] 
                  )

                  
                  sp = Speciman.find_by(:tracking_number => tracking_number)
                  sp.couch_id = c_order['_id']
                  sp.save()
                  couch_order = c_order['_id']
            end              

            return [true,tracking_number,couch_order]
      end


      def self.get_order_by_tracking_number_sql(track_number)
            details =   Speciman.where(tracking_number: track_number).first
            if details
                  return details
            else
                  return false
            end
      end

      def self.retrieve_order_from_couch(couch_id)
            settings = YAML.load_file("#{Rails.root.to_s}/config/couchdb.yml")[Rails.env]
            ip = settings['host']
            protocol = settings['protocol']
            port = settings['port']
            username = settings['username']
            password = settings['password']
            db_name =  settings['prefix'].to_s + "_order_" + settings['suffix'].to_s

            retr_order = JSON.parse(RestClient.get("#{protocol}://#{username}:#{password}@#{ip}:#{port}/#{db_name}/#{couch_id}"))
            return retr_order
      end

      def self.update_couch_order(track_number,order)
            settings = YAML.load_file("#{Rails.root.to_s}/config/couchdb.yml")[Rails.env]
            ip = settings['host']
            protocol = settings['protocol']
            port = settings['port']
            username = settings['username']
            password = settings['password']
            db_name =  settings['prefix'].to_s + "_order_" + settings['suffix'].to_s

            url = "#{protocol}://#{username}:#{password}@#{ip}:#{port}/#{db_name}"
            RestClient.post(url,order.to_json, :content_type => 'application/json')
      end

      def self.query_results_by_npid(npid)

            ord = Speciman.find_by_sql("SELECT specimen.id AS trc, specimen.tracking_number AS track,specimen_types.name AS spec_name FROM specimen
                                    INNER JOIN specimen_types ON specimen_types.id = specimen.specimen_type_id
                                    INNER JOIN tests ON tests.specimen_id = specimen.id
                                    INNER JOIN patients ON patients.id = tests.patient_id
                                    WHERE patients.patient_number='#{npid}'")
            info = {}
            if ord.length > 0 
                  checker = false;
                  ord.each do |ord_lo|
                        r = Test.find_by_sql(   "SELECT test_types.name AS tst_type, tests.id AS tst_id FROM test_types
                                                INNER JOIN tests ON test_types.id = tests.test_type_id
                                                INNER JOIN specimen ON specimen.id = tests.specimen_id
                                                WHERE specimen.id ='#{ord_lo.trc}'"
                              )
                        
                        if r.length > 0
                              test_re = {}
                              r.each do |te|

                                    res = Speciman.find_by_sql( "SELECT measures.name AS measure_name, test_results.result AS result,
                                                      tests.id AS tstt_id
                                                      FROM specimen INNER JOIN tests ON tests.specimen_id = specimen.id
                                                      INNER JOIN test_results ON test_results.test_id = tests.id
                                                      INNER JOIN measures ON measures.id = test_results.measure_id
                                                      WHERE specimen.id  = '#{ord_lo.trc}' AND 
                                                      test_results.test_id ='#{te.tst_id}'"
                                                )
                                    results = {}
                                   
                                    if res.length > 0
                                          res.each do |re|
                                                tet_id = re.tstt_id
                                                $ts = TestStatusTrail.find_by_sql("SELECT max(test_status_trails.created_at), 
                                                                        test_statuses.name AS st_name
                                                                        FROM test_statuses 
                                                                        INNER JOIN test_status_trails
                                                                        ON test_status_trails.test_status_id = 
                                                                        test_statuses.id 
                                                                        INNER JOIN tests ON tests.id = 
                                                                        test_status_trails.test_id
                                                                        WHERE tests.id='#{tet_id}' GROUP BY test_statuses.name
                                                                        ")
                                               
                                              results[re.measure_name] = re.result
                                          end
                                          test_re[te.tst_type] = {'test_result': results,
                                                                  'test_status': $ts[0].st_name
                                                                 }
                                          checker = true
                                    else
                                          test_re[te.tst_type] = {}
                                    end

                              end                             
                    
                        end
                        info[ord_lo.track] = { 'sample_type': ord_lo.spec_name, 
                                             'tests': test_re
                                          }
                  end

                  if checker == true
                        return info
                  else
                        return checker
                  end

            else
                  return false
            end

      end

      def self.query_results_by_tracking_number(tracking_number)

            r = Test.find_by_sql(   "SELECT test_types.name AS tst_type, tests.id AS tst_id FROM test_types
                                    INNER JOIN tests ON test_types.id = tests.test_type_id
                                    INNER JOIN specimen ON specimen.id = tests.specimen_id
                                    WHERE specimen.tracking_number ='#{tracking_number}'"
                  )
            checker = false;
            r_date = ""
            if r.length > 0
                  test_re = {}
                  r.each do |te|

                        res = Speciman.find_by_sql( "SELECT measures.name AS measure_name, test_results.result AS result, test_results.time_entered AS time_entered
                                          FROM specimen INNER JOIN tests ON tests.specimen_id = specimen.id
                                          INNER JOIN test_results ON test_results.test_id = tests.id
                                          INNER JOIN measures ON measures.id = test_results.measure_id
                                          WHERE specimen.tracking_number  = '#{tracking_number}' AND 
                                          test_results.test_id ='#{te.tst_id}'"
                                    )
                        results = {}
                        
                        if res.length > 0
                              res.each do |re|

                                  results[re.measure_name] = re.result
                                  r_date =  re.time_entered
                              end
			      results['result_date'] = r_date.to_date rescue nil
                              test_re[te.tst_type] = results
                              checker = true
                        else
                              test_re[te.tst_type] = {}
                        end

                  end
                  if checker == true
                        return test_re
                  else
                        return checker
                  end
            else
                  return false
            end
      end

      def self.dispatch_sample(tracking_number,first,last)
            SpecimenDispatch.create(
                  tracking_number: tracking_number,
                  dispatcher_name: first + " "+ last,
                  date_dispatched: Time.now.strftime("%Y%m%d%H%M%S") 
            )

            return true
      end

      def self.check_if_dispatched(tracking_number)
            rs = SpecimenDispatch.find_by_sql("SELECT * FROM specimen_dispatches WHERE tracking_number='#{tracking_number}'")
            if rs.length > 0
                  return true
            else  
                  return false
            end
      end

      def self.request_order(params,tracking_number)
            couch_order = 0
            ActiveRecord::Base.transaction do 

                  npid = params[:national_patient_id]
                  patient_obj = Patient.where(:patient_number => npid)
                
                  patient_obj = patient_obj.first unless patient_obj.blank?

                        if patient_obj.blank?
                              patient_obj = patient_obj.create(
                                                patient_number: npid,
                                                name: params[:first_name] +" "+ params[:last_name],
                                                email: '' ,
                                                dob: params[:date_of_birth],
                                                gender: params[:gender],
                                                phone_number: params[:phone_number],
                                                address: "",
                                                external_patient_number:  "" 

                                                )
                                 
                        end

                                    
                  who_order = {
                        :first_name => params[:who_order_test_first_name],
                        :last_name => params[:who_order_test_last_name],
                        :phone_number => params[:who_order_test_phone_number],
                        :id => params[:who_order_test_id]
                  }

                  patient = {
                        :first_name => params[:first_name],
                        :last_name => params[:last_name],
                        :phone_number => params[:phone_number],
                        :id => npid,
                        :email => params[:email],
                        :gender => params[:gender] 
                  }
                  sample_status =  {}
                  test_status = {}
                  time = Time.now.strftime("%Y%m%d%H%M%S") 
                  sample_status[time] = {
                        "status" => "Drawn",
                              "updated_by":  {
                                    :first_name => params[:who_order_test_first_name],
                                    :last_name => params[:who_order_test_last_name],
                                    :phone_number => params[:who_order_test_phone_number],
                                    :id => params[:who_order_test_id] 
                                    }
                  }


                  #sample_type_id = SpecimenType.get_specimen_type_id(params[:sample_type])
                  sample_status_id = SpecimenStatus.get_specimen_status_id('specimen_not_collected')
                 

            sp_obj =  Speciman.create(
                        :tracking_number => tracking_number,
                        :specimen_type_id => 0,
                        :specimen_status_id =>  sample_status_id,
                        :couch_id => '',
                        :ward_id => Ward.get_ward_id(params[:order_location]),
                        :priority => params[:sample_priority],
                        :drawn_by_id => params[:who_order_test_id],
                        :drawn_by_name =>  params[:who_order_test_first_name] + " " + params[:who_order_test_last_name],
                        :drawn_by_phone_number => params[:who_order_test_phone_number],
                        :target_lab => 'not_assigned',
                        :art_start_date => Time.now,
                        :sending_facility => params[:health_facility_name],
                        :requested_by =>  params[:requesting_clinician],
                        :district => params[:district],
                        :date_created => time
                  )

                  
                        res = Visit.create(
                                 :patient_id => npid,
                                 :visit_type_id => '',
                                 :ward_id => Ward.get_ward_id(params[:order_location])
                              )
                        visit_id = res.id

                  params[:tests].each do |tst|
                        tst = tst.gsub("&amp;",'&')
                        status = check_test(tst)
                        if status == false
                              details = {}
                              details[time] = {
                                    "status" => "Drawn",
                                    "updated_by":  {
                                          :first_name => params[:who_order_test_first_name],
                                          :last_name => params[:who_order_test_last_name],
                                          :phone_number => params[:who_order_test_phone_number],
                                          :id => params[:who_order_test_id] 
                                          }
                              }
                              test_status[tst] = details                  
                              rst = TestType.get_test_type_id(tst)
                              rst2 = TestStatus.get_test_status_id('drawn')

                              Test.create(
                                    :specimen_id => sp_obj.id,
                                    :test_type_id => rst,
                                    :patient_id => patient_obj.id,
                                    :created_by => params[:who_order_test_first_name] + " " + params[:who_order_test_last_name],
                                    :panel_id => '',
                                    :time_created => time,
                                    :test_status_id => rst2
                              )
                        else
                              pa_id = PanelType.where(name: tst).first
                              res = TestType.find_by_sql("SELECT test_types.id FROM test_types INNER JOIN panels 
                                                            ON panels.test_type_id = test_types.id
                                                            INNER JOIN panel_types ON panel_types.id = panels.panel_type_id
                                                            WHERE panel_types.id ='#{pa_id.id}'")
                              res.each do |tt|
                                    details = {}
                                    details[time] = {
                                          "status" => "Drawn",
                                          "updated_by":  {
                                                :first_name => params[:who_order_test_first_name],
                                                :last_name => params[:who_order_test_last_name],
                                                :phone_number => params[:who_order_test_phone_number],
                                                :id => params[:who_order_test_id] 
                                                }
                                    }
                                    test_status[tst] = details                  
                                    #rst = TestType.get_test_type_id(tt)
                                    rst2 = TestStatus.get_test_status_id('drawn')
                                    Test.create(
                                          :specimen_id => sp_obj.id,
                                          :test_type_id => tt.id,
                                          :patient_id => patient_obj.id,
                                          :created_by => params[:who_order_test_first_name] + " " + params[:who_order_test_last_name],
                                          :panel_id => '',
                                          :time_created => time,
                                          :test_status_id => rst2
                                    )
                              end
                        end
                  end
                  
                  couch_tests = {}
                  params[:tests].each do |tst|
                        couch_tests[tst] = {
                              'results': {},
                              'date_result_entered': '',
                              'result_entered_by': {}                             
                        }
                  end

            c_order  =  Order.create(
                        tracking_number: tracking_number,
                        sample_type: 'not_assigned',
                        date_created: params[:date_sample_drawn],
                        sending_facility: params[:health_facility_name],
                        receiving_facility: 'not_assigned',
                        tests: params[:tests],
                        test_results: couch_tests,
                        patient: patient,
                        order_location: params[:order_location] ,
                        districy: params[:district],
                        priority: params[:sample_priority],
                        who_order_test: who_order,
                        sample_statuses: sample_status,
                        test_statuses: test_status,
                        sample_status: "specimen_not_collected" 
                  )

                  sp = Speciman.find_by(:tracking_number => tracking_number)
                  sp.couch_id = c_order['_id']
                  sp.save()
                  couch_order = c_order['_id']
            end              

            return [true,tracking_number,couch_order]
      end


      def self.confirm_order_request(ord)
            specimen_type = ord['specimen_type']
            target_lab = ord['target_lab']
            rejecter = {}  
            st = SpecimenType.find_by_sql("SELECT id AS type_id FROM specimen_types WHERE name='#{specimen_type}'")
            type_id = st[0]['type_id']
            obj = Speciman.find_by(:tracking_number => ord['tracking_number'])
            couch_id = obj['couch_id']
            
            obj.specimen_type_id = type_id
            obj.target_lab = target_lab
            obj.specimen_status_id =  sp_id = SpecimenStatus.find_by(:name => 'specimen_collected')['id']
            obj.save            
        
            retr_order = OrderService.retrieve_order_from_couch(couch_id)          
            retr_order['sample_type'] = specimen_type
            retr_order['receiving_facility'] = target_lab   
            retr_order['sample_status']      = 'specimen_collected'
            puts  "-----checking"
   
      
            OrderService.update_couch_order(couch_id,retr_order)
      end


      def self.query_requested_order_by_npid(npid)

            sp_id = SpecimenStatus.find_by(:name => 'specimen_not_collected')['id']
            sp_id2 = SpecimenStatus.find_by(:name => 'specimen_collected')['id']

                  r = Speciman.find_by_sql("SELECT distinct(specimen.id) FROM specimen INNER JOIN tests ON specimen.id = tests.specimen_id INNER JOIN patients ON patients.id = tests.patient_id WHERE patients.patient_number = '#{npid}'")
                 
                  if r.length > 0       
                        counter = 0
                        details =[]
                        det = {}
                        got_tsts =  false
                        checker = []
                        tste = []
                        r.each do |data|
                              tra_num = data['id']
                              if !checker.include?(tra_num)
                                    da = Speciman.find_by_sql("SELECT * FROM specimen WHERE id='#{tra_num}'")
                                    
                                    checker.push(tra_num)
                                    tst = Test.find_by_sql("SELECT * FROM tests INNER JOIN test_types ON tests.test_type_id = test_types.id WHERE tests.specimen_id='#{data['id']}'")
                                   
                                    if tst.length > 0
                                          tst.each do |t_name| 
                                                                                          
                                                tste.push(t_name['name'])
                                          end
                                    end
                                   
                                    set_specimen_type_id =  da[0]['specimen_type_id'].to_i
                                    if set_specimen_type_id == 0
                                      set_specimen_type_id = 'not-assigned'
                                    end

                                    puts "------------------#{set_specimen_type_id}"
                                    puts set_specimen_type_id
                                    puts "sample type --------------------"
				      begin
                                    spc_type = SpecimenType.find_by_sql("SELECT name FROM specimen_types WHERE id ='#{set_specimen_type_id}'")[0]['name'] if set_specimen_type_id != "not-assigned" && !set_specimen_type_id.blank?
                                    spc_type = "not-assigned" if set_specimen_type_id == "not-assigned" || set_specimen_type_id.blank?
                              rescue
					      next
				      end
                                    det ={   
                                          requested_by: da[0]['requested_by'],
                                          date_created:   da[0]['date_created'],
                                          specimen_type: spc_type ,
                                          tracking_number: da[0]['tracking_number'],
                                          tests: tste
                                    }
                                    details[counter] = det
                                    det = {}
                                    tste = []
                                    counter = counter + 1
                              end
                        end   
                        
                        return details  
                        
                  else
                        return false
                  end  

      end

      def self.query_order_by_npid(npid)

    
                  res = Speciman.find_by_sql("SELECT specimen_types.name AS spc_type, specimen.tracking_number AS track_number, specimen.id AS _id, 
                                    specimen.date_created AS dat_created
                                    FROM specimen INNER JOIN specimen_types 
                                    ON specimen_types.id = specimen.specimen_type_id")

                  
                  counter = 0
                  details =[]
                  det = {}
                  tste = []
                  got_tsts =  false

                  if res.length > 0
                        res.each do |gde|
                              specimen_id = gde['_id']
                              tst = Speciman.find_by_sql("SELECT test_types.name AS tst_name FROM test_types 
                                          INNER JOIN tests ON tests.test_type_id = test_types.id
                                          INNER JOIN specimen  ON specimen.id = tests.specimen_id
                                          INNER JOIN patients ON patients.id = tests.patient_id
                                          WHERE tests.specimen_id ='#{specimen_id}' AND patients.patient_number ='#{npid}'")

                              
                              tst.each do |ty|
                                    tste.push(ty['tst_name'])
                                    got_tsts = true
                              end
                              if got_tsts == true      
                                          det ={
                                                specimen_type: gde['spc_type'],
                                                tracking_number: gde['track_number'],
                                                date_created: gde['dat_created'],
                                                tests: tste
                                          }

                                    details[counter] =  det

                                    counter = counter + 1
                                    tste = []
                                    got_tsts =  false
                              end
                        end   
                        counter = 0
                        return details
                  else
                        return false
                  end
   
      end

      def self.check_test(tst)

            res = PanelType.find_by_sql("SELECT * FROM panel_types WHERE name ='#{tst}'")

            if res.length > 0
                  return true
            else
                  return false
            end

      end

      def self.update_order(ord)
            status = ord['status']      
            rejecter = {}  
            st = SpecimenStatus.find_by_sql("SELECT id AS status_id FROM specimen_statuses WHERE name='#{status}'")
            status_id = st[0]['status_id']
            obj = Speciman.find_by(:tracking_number => ord['tracking_number'])
            couch_id = obj['couch_id']
            obj.specimen_status_id = status_id
            obj.save            
            SpecimenStatusTrail.create(
                  :specimen_id => obj.id,
                  :specimen_status_id => status_id,
                  :time_updated => Time.new.strftime("%Y%m%d%H%M%S"),
                  :who_updated_id => ord['who_updated']['id'],
                  :who_updated_name => ord['who_updated']['first_name'] + " " +  ord['who_updated']['last_name'],
                  :who_updated_phone_number => ord['who_updated']['phone_number'],
            )
            retr_order = OrderService.retrieve_order_from_couch(couch_id)          
            curent_status_trail = retr_order['sample_statuses']
            curent_status_trail[Time.now.strftime("%Y%m%d%H%M%S")] = {
                  "status": status,
                  "updated_by":  {
                        :first_name => ord[:who_updated]['first_name'],
                        :last_name => ord[:who_updated]['last_name'],
                        :phone_number => '',
                        :id => ord[:who_updated]['id_number'] 
                        }
            }
            retr_order['sample_statuses'] = curent_status_trail
            retr_order['sample_status'] = status         
            puts  "-----checking"
            puts ord
            if !ord['who_rejected'].blank?
                  retr_order['who_rejected'] = {
                        'first_name': ord['who_rejected']['first_name'],
                        'last_name': ord['who_rejected']['last_name'],
                        'phone_number': '',
                        'id': ord['who_rejected']['id_number'],                        
                        'rejection_explained_to': ord['who_rejected']['person_talked_to'],
                        'reason_for_rejection': ord['who_rejected']['reason_for_rejection']
                        
                  }
            end
            OrderService.update_couch_order(couch_id,retr_order)
      end

      def self.query_order_by_tracking_number(tracking_number)

            res = Speciman.find_by_sql("SELECT specimen_types.name AS sample_type, specimen_statuses.name AS specimen_status,
                              wards.name AS order_location, specimen.date_created AS date_created, specimen.priority AS priority,
                              specimen.drawn_by_id AS drawer_id, specimen.drawn_by_name AS drawer_name,
                              specimen.drawn_by_phone_number AS drawe_number, specimen.target_lab AS target_lab, 
                              specimen.sending_facility AS health_facility, specimen.requested_by AS requested_by,
                              specimen.date_created AS date_drawn,
                              patients.patient_number AS pat_id, patients.name AS pat_name,
                              patients.dob AS dob, patients.gender AS sex 
                              FROM specimen INNER JOIN specimen_statuses ON specimen_statuses.id = specimen.specimen_status_id
                              LEFT JOIN specimen_types ON specimen_types.id = specimen.specimen_type_id
                              INNER JOIN tests ON tests.specimen_id = specimen.id
                              INNER JOIN patients ON patients.id = tests.patient_id
                              LEFT JOIN wards ON specimen.ward_id = wards.id
                              WHERE specimen.tracking_number ='#{tracking_number}' ")
            tsts = {}
           
            if res.length > 0
                  res = res[0]
                  tst = Test.find_by_sql("SELECT test_types.name AS test_name, test_statuses.name AS test_status
                                          FROM tests
                                          INNER JOIN specimen ON specimen.id = tests.specimen_id
                                          INNER JOIN test_types ON test_types.id = tests.test_type_id
                                          INNER JOIN test_statuses ON test_statuses.id = tests.test_status_id
                                          WHERE specimen.tracking_number ='#{tracking_number}'"
                              )

                  if tst.length > 0
                        tst.each do |t|
                              tsts[t.test_name] = t.test_status
                        end
                  end

                  return { 

                        gen_details:   {  sample_type: res.sample_type,
                                          specimen_status: res.specimen_status,
                                          order_location: res.order_location,
                                          date_created: res.date_created,
                                          priority: res.priority,
                                          sample_created_by: {
                                                      id: res.drawe_number,
                                                      name: res.drawer_name,
                                                      phone: res.drawe_number
                                                },
                                          patient: {
                                                      id: res.pat_id,
                                                      name: res.pat_name,
                                                      gender: res.sex,
                                                      dob: res.dob
                                                },
                                          receiving_lab: res.target_lab,
                                          sending_lab: res.health_facility,
                                          requested_by: res.requested_by                                         
                                          },
                                          tests: tsts
                  }
                  
            else
                  return false
            end

      end
end







