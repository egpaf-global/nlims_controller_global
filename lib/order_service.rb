
module  OrderService

      def self.create_order(params,tracking_number)
            ActiveRecord::Base.transaction do 

                  npid = params[:national_patient_id]
                  patient_obj = Patient.where(id: npid)

                  patient_obj = patient_obj.first unless patient_obj.blank?

                        if patient_obj.blank?
                              patient_obj = patient_obj.create(
                                                id: npid, 
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


                  sample_type_id = SpecimenType.get_specimen_type_id(params[:sample_type])
                  sample_status_id = SpecimenStatus.get_specimen_status_id('specimen_not_collected')
                 

            sp_obj =  Speciman.create(
                        :tracking_number => tracking_number,
                        :specimen_type_id =>  sample_type_id,
                        :specimen_status_id =>  sample_status_id,
                        :priority => params[:sample_priority],
                        :drawn_by_id => params[:who_order_test_id],
                        :drawn_by_name =>  params[:who_order_test_first_name] + " " + params[:who_order_test_last_name],
                        :drawn_by_phone_number => params[:who_order_test_phone_number],
                        :target_lab => params[:target_lab],
                        :art_start_date => Time.now,
                        :sending_facility => params[:health_facility_name],
                        :requested_by => "",
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
                              :visit_id => visit_id,
                              :created_by => params[:who_order_test_first_name] + " " + params[:who_order_test_last_name],
                              :panel_id => '',
                              :time_created => time,
                              :test_status_id => rst2
                        )
                  end
                  
                  couch_tests = {}
                  params[:tests].each do |tst|
                        couch_tests[tst] = {
                              'results': {},
                              'date_result_entered': '',
                              'result_entered_by': {}                             
                        }
                  end

                  Order.create(
                        _id: tracking_number,
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
                        sample_status: "specimen_not_collected" 
                  )



            end              

            return [true,tracking_number]
      end


      def self.get_order_by_tracking_number_sql(track_number)
          details =   Speciman.where(tracking_number: track_number).first
            if details
                  return details
            else
                  return false
            end
      end

      def self.retrieve_order_from_couch(tracking_number)
            retr_order = JSON.parse(RestClient.get("http://root:amin9090!@localhost:5984/nlims_order_repo/#{tracking_number}"))
            return retr_order
      end

      def self.update_couch_order(track_number,order)
            url = "http://root:amin9090!@localhost:5984/nlims_order_repo"
            RestClient.post(url,order.to_json, :content_type => 'application/json')
      end

      def self.query_results_by_npid(npid)

            ord = Speciman.find_by_sql("SELECT specimen.id AS trc, specimen_types.name AS spec_name FROM specimen
                                    INNER JOIN specimen_types ON specimen_types.id = specimen.specimen_type_id
                                    INNER JOIN tests ON tests.specimen_id = specimen.id
                                    INNER JOIN visits ON visits.id = tests.visit_id
                                    INNER JOIN patients ON patients.id = visits.patient_id
                                    WHERE patients.id='#{npid}'")
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
                        info[ord_lo.trc] = { 'sample_type': ord_lo.spec_name, 
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
            if r.length > 0
                  test_re = {}
                  r.each do |te|

                        res = Speciman.find_by_sql( "SELECT measures.name AS measure_name, test_results.result AS result
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
                              end
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

      def self.query_order_by_npid(npid)

    
                  res = Speciman.find_by_sql("SELECT specimen_types.name AS spc_type, specimen.id AS track_number, 
                                    specimen.date_created AS dat_created
                                    FROM specimen INNER JOIN specimen_types 
                                    ON specimen_types.id = specimen.specimen_type_id
                                    INNER JOIN tests ON tests.specimen_id = specimen.id
                                    INNER JOIN visits ON visits.id = tests.visit_id
                                    INNER JOIN patients ON patients.id = visits.patient_id
                                    WHERE patients.id ='#{npid}'")

                  
                  counter = 0
                  details =[]
                  det = {}
                  tste = []

                  if res.length > 0
                        res.each do |gde|
                              specimen_id = gde['id']
                              tst = Speciman.find_by_sql("SELECT test_types.name AS tst_name FROM test_types 
                                          INNER JOIN tests ON tests.test_type_id = test_types.id
                                          INNER JOIN specimen  ON specimen.id = tests.specimen_id
                                          WHERE tests.specimen_id ='#{specimen_id}'")

                              
                              tst.each do |ty|
                                    tste.push(ty['tst_name'])
                              end
                              
                                    det ={
                                          specimen_type: gde['spc_type'],
                                          tracking_number: gde['track_number'],
                                          date_created: gde['dat_created'],
                                          tests: tste
                                    }

                              details[counter] =  det


                        counter = counter + 1
                        tste = []
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
            retr_order = OrderService.retrieve_order_from_couch(ord['tracking_number'])          
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
            OrderService.update_couch_order(ord['tracking_number'],retr_order)
      end

      def self.query_order_by_tracking_number(tracking_number)

            res = Speciman.find_by_sql("SELECT specimen_types.name AS sample_type, specimen_statuses.name AS specimen_status,
                              wards.name AS order_location, specimen.date_created AS date_created, specimen.priority AS priority,
                              specimen.drawn_by_id AS drawer_id, specimen.drawn_by_name AS drawer_name,
                              specimen.drawn_by_phone_number AS drawe_number, specimen.target_lab AS target_lab, 
                              specimen.sending_facility AS health_facility, specimen.requested_by AS requested_by,
                              specimen.date_created AS date_drawn,
                              patients.id AS pat_id, patients.name AS pat_name,
                              patients.dob AS dob, patients.gender AS sex 
                              FROM specimen INNER JOIN specimen_statuses ON specimen_statuses.id = specimen.specimen_status_id
                              INNER JOIN specimen_types ON specimen_types.id = specimen.specimen_type_id
                              INNER JOIN tests ON tests.specimen_id = specimen.id
                              INNER JOIN visits ON visits.id = tests.visit_id
                              INNER JOIN wards ON wards.id = visits.ward_id
                              INNER JOIN patients ON visits.patient_id = patients.id
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






