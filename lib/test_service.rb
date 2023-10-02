require 'order_service.rb'
module TestService


  def self.update_test(params)
    return [false, 'tracking number not provided'] if params[:tracking_number].blank?
    return [false, 'test name not provided'] if params[:test_name].blank?
    return [false, 'test status not provided'] if params[:test_status].blank?

    sql_order = OrderService.get_order_by_tracking_number_sql(params[:tracking_number])
    if params[:result_date].blank?
      result_date = Time.now.strftime("%Y%m%d%H%M%S")
    else
      result_date = params[:result_date]
    end
    if !sql_order == false
      order_id = sql_order.id
      # couch_id = sql_order.couch_id
      test_name = params[:test_name]
      # test_name = test_name.gsub("_", " ")
      # retr_order = OrderService.retrieve_order_from_couch(couch_id)

      return [false, 'wrong parameter on test name provided'] if TestType.find_by_name(test_name).blank?
      if TestStatus.find_by_name(params[:test_status]).blank?
        return [false, 'test status provided, not within scope of tests statuses']
      end

      test_id = Test.find_by_sql("SELECT tests.id
	  							  FROM tests
								  JOIN test_types
								  ON tests.test_type_id = test_types.id
							      WHERE tests.specimen_id = '#{order_id}'
								  AND test_types.name = '#{test_name}'").first.id
      test_status = TestStatus.where(name: params[:test_status]).first
      # couch_id_updater = 0
      if !test_id.blank?
        checker = check_if_test_updated?(test_id, test_status.id)
        if checker == false
          if params[:results]
            results = params[:results]
            results.each do |measure_name, result_value|
              measure = Measure.where(name: measure_name).first
              return [false, "measure #{measure_name} does not exist"] if measure.blank?
              
              if check_if_result_already_available(test_id, measure.id) == false
                TestResult.create!(
                  measure_id: measure.id,
                  test_id: test_id,
                  result: result_value,
                  device_name: '',
                  time_entered: result_date
                )
              else
                TestResult.where(test_id: test_id,
                                 measure_id: measure.id).first.update(result: result_value,
                                                                      time_entered: result_date)
              end
              # test_results_measures[measure_name] = { 'result_value': result_value }
            end
            # results_measure[test_name] = test_results_measures

            test_status = TestStatus.where(name: params[:test_status]).first
            tst_update = Test.find(test_id)
            # couch_id_updater = tst_update.test_status_id
            if tst_update.test_status_id == 9 && test_status.id == 3
              tst_update.test_status_id = test_status.id
              tst_update.save

              TestStatusTrail.create!(
                test_id: test_id,
                time_updated: params[:time_updated],
                test_status_id: test_status.id,
                who_updated_id: params[:who_updated]['id_number'].to_s,
                who_updated_name: params[:who_updated]['first_name'].to_s + " " + params[:who_updated]['last_name'].to_s,
                who_updated_phone_number: ''

              )
            elsif tst_update.test_status_id == 3 && test_status.id == 4
              tst_update.test_status_id = test_status.id
              tst_update.save

              TestStatusTrail.create!(
                test_id: test_id,
                time_updated: params[:time_updated],
                test_status_id: test_status.id,
                who_updated_id: params[:who_updated]['id_number'].to_s,
                who_updated_name: params[:who_updated]['first_name'].to_s + " " + params[:who_updated]['last_name'].to_s,
                who_updated_phone_number: ''

              )
            elsif tst_update.test_status_id == 4 && test_status.id == 5
              tst_update.test_status_id = test_status.id
              tst_update.save

              TestStatusTrail.create!(
                test_id: test_id,
                time_updated: params[:time_updated],
                test_status_id: test_status.id,
                who_updated_id: params[:who_updated]['id_number'].to_s,
                who_updated_name: params[:who_updated]['first_name'].to_s + " " + params[:who_updated]['last_name'].to_s,
                who_updated_phone_number: ''

              )
            elsif test_status.id == 8
              tst_update.test_status_id = test_status.id
              tst_update.save

              TestStatusTrail.create!(
                test_id: test_id,
                time_updated: params[:time_updated],
                test_status_id: test_status.id,
                who_updated_id: params[:who_updated]['id_number'].to_s,
                who_updated_name: params[:who_updated]['first_name'].to_s + " " + params[:who_updated]['last_name'].to_s,
                who_updated_phone_number: ''

              )
            end

          else
              test_status = TestStatus.where(name: params[:test_status]).first
              tst_update = Test.find(test_id)
              # couch_id_updater = tst_update.test_status_id

              if tst_update.test_status_id == 9 && test_status.id == 3
                tst_update.test_status_id = test_status.id
                tst_update.save

        TestStatusTrail.create!(
                  test_id: test_id,
                  time_updated: params[:time_updated],
                  test_status_id: test_status.id,
                  who_updated_id: params[:who_updated]['id_number'].to_s,
                  who_updated_name: params[:who_updated]['first_name'].to_s + " " + params[:who_updated]['last_name'].to_s,
                  who_updated_phone_number: ''

                )
              elsif tst_update.test_status_id == 3 && test_status.id == 4
                tst_update.test_status_id = test_status.id
                tst_update.save

                TestStatusTrail.create!(
                  test_id: test_id,
                  time_updated: params[:time_updated],
                  test_status_id: test_status.id,
                  who_updated_id: params[:who_updated]['id_number'].to_s,
                  who_updated_name: params[:who_updated]['first_name'].to_s + " " + params[:who_updated]['last_name'].to_s,
                  who_updated_phone_number: ''

                )
              elsif tst_update.test_status_id == 4 && test_status.id == 5
                tst_update.test_status_id = test_status.id
                tst_update.save

                TestStatusTrail.create!(
                  test_id: test_id,
                  time_updated: params[:time_updated],
                  test_status_id: test_status.id,
                  who_updated_id: params[:who_updated]['id_number'].to_s,
                  who_updated_name: params[:who_updated]['first_name'].to_s + " " + params[:who_updated]['last_name'].to_s,
                  who_updated_phone_number: ''

                )
              elsif test_status.id == 8
                tst_update.test_status_id = test_status.id
                tst_update.save

                TestStatusTrail.create!(
                  test_id: test_id,
                  time_updated: params[:time_updated],
                  test_status_id: test_status.id,
                  who_updated_id: params[:who_updated]['id_number'].to_s,
                  who_updated_name: params[:who_updated]['first_name'].to_s + " " + params[:who_updated]['last_name'].to_s,
                  who_updated_phone_number: ''

                )
              end

          end

        #   if !results_measure.blank?
        #     # retr_order = OrderService.retrieve_order_from_couch(couch_id)

        #     if retr_order != "false"

        #       couch_test_statuses = retr_order['test_statuses'][test_name]
        #       couch_test_statuses[time] =  details if !couch_test_statuses.blank?
        #       retr_order['test_statuses'][test_name] =  couch_test_statuses

        #       retr_order['test_results'][test_name] = {
        #         'results': test_results_measures,
        #         'date_result_entered': result_date,
        #         'result_entered_by': {
        #           :first_name => params[:who_updated]['first_name'],
        #           :last_name => params[:who_updated]['last_name'],
        #           :phone_number => '',
        #           :id => params[:who_updated]['id_number']
        #         }
        #         }


        #       if couch_id_updater == 9 && params[:test_status] == "started"
        #         OrderService.update_couch_order(couch_id, retr_order)
        #       elsif couch_id_updater == 3 && params[:test_status] == "completed"
        #         OrderService.update_couch_order(couch_id, retr_order)
        #       elsif couch_id_updater == 4 && params[:test_status] == "verified"
        #         OrderService.update_couch_order(couch_id, retr_order)
        #       elsif params[:test_status] == "test-rejected"
        #         OrderService.update_couch_order(couch_id, retr_order)
        #       end
        #     end
        #   else
        #     retr_order = OrderService.retrieve_order_from_couch(couch_id)

        #     if retr_order != "false"

        #       couch_test_statuses = retr_order['test_statuses'][test_name]
        #       couch_test_statuses[time] =  details if !couch_test_statuses.blank?
        #       retr_order['test_statuses'][test_name] =  couch_test_statuses
        #       if couch_id_updater == 9 && params[:test_status] == "started"
        #         OrderService.update_couch_order(couch_id, retr_order)
        #       elsif couch_id_updater == 3 && params[:test_status] == "completed"

        #         OrderService.update_couch_order(couch_id, retr_order)
        #       elsif couch_id_updater == 4 && params[:test_status] == "verified"
        #         OrderService.update_couch_order(couch_id, retr_order)
        #       elsif params[:test_status] == "test-rejected"
        #         OrderService.update_couch_order(couch_id, retr_order)
        #       end
        #     end
        #   end
          return [true, ""]
        else
          return [false, "test already updated with such state"]
        end

      else
        return [false, "order with such test not available"]
      end
    else
      return [false, "order not available"]
    end
  end

  def self.check_if_result_already_available(test_id, measure_id)
    result = TestResult.find_by_sql("SELECT * FROM test_results
								  WHERE test_id=#{test_id}
								  AND measure_id=#{measure_id}")
    result.blank? ? false : true
  end

  def self.acknowledge_test_results_receiptient(tracking_number, test_name, date, recipient_type)

     test_name = "Viral Load" if test_name == "HIV viral load"
     test_name = "CD4" if test_name == "CD4 count"
     res = Test.find_by_sql("SELECT tests.id FROM tests INNER JOIN test_types ON test_types.id = tests.test_type_id
                                                        INNER JOIN specimen ON specimen.id = tests.specimen_id
                                                        where specimen.tracking_number ='#{tracking_number}' AND test_types.name='#{test_name}'")

     if !res.blank?

                         type = TestResultRecepientType.find_by(:name => recipient_type)
                         tst = Test.find_by(:id => res[0]['id'])
                         tst.test_result_receipent_types = type.id
                         tst.result_given = true
                         tst.date_result_given = date
                         tst.save

       #check = ResultsAcknwoledge.find_by(:tracking_number => tracking_number, :acknwoledged_by => "emr_at_facility")
         #if check.blank?
       #   tr = ResultsAcknwoledge.create(
             #	tracking_number: tracking_number,
             #	test_id: res[0]['id'],
             #	acknwoledged_at:  date,
             #	result_date: date,
             #	acknwoledged_by: "emr_at_facility",
             #	acknwoledged_to_nlims: false,
              #	 acknwoledment_level: 2
       #      )
       #end
                         obj = Speciman.find_by(:tracking_number => tracking_number)
                         couch_id = obj['couch_id'] if !obj['couch_id'].blank?

                         retr_order = OrderService.retrieve_order_from_couch(couch_id)
                 #puts "hello"
                                 #puts retr_order
                                 #raise retr_order.inspect
                         if !retr_order['tracking_number'].blank?
                         test_ackn = {}
                         test_ackn[test_name] = {
                                 'result_recepient_type': recipient_type ,
                                 'result_given': "true",
                                 'date_result_give;': date
                         }

                         new_acknow = retr_order['results_acknowledgement']
                         new_acknow = test_ackn
                         retr_order['results_acknowledgement'] = new_acknow
                         OrderService.update_couch_order(couch_id, retr_order)
                         end

                         return true
                 else
                         return false
                 end

  end

  def self.check_if_test_updated?(test_id, status_id)
    test = Test.find_by(id: test_id, test_status_id: status_id)
    test.blank? ? false : true
  end

  def self.test_no_results(npid)

    res = Test.find_by_sql("SELECT tests.time_created,test_types.name, test_statuses.name AS test_status, tests.id AS tst_id, specimen.tracking_number
							FROM tests INNER JOIN test_statuses ON test_statuses.id = tests.test_status_id INNER JOIN test_types
							ON test_types.id = tests.test_type_id
							INNER JOIN patients ON patients.id = tests.patient_id
							INNER JOIN specimen ON specimen.id = tests.specimen_id
							WHERE patients.patient_number='#{npid}' AND (tests.test_status_id != '4' AND tests.test_status_id != '5')")
    data = []
    if !res.blank?
      res.each do |d|
        data.push({'tracking_number': d['tracking_number'], 'test_name': d['name'], 'created_at': d['time_created'].to_date, 'status': d['test_status']})
      end
      return [true, data]
    else
      return [false, '']
    end
  end

  def self.query_test_status(tracking_number)
    spc_id = Speciman.find_by(:tracking_number => tracking_number)['id']
    status = Test.find_by_sql("SELECT test_statuses.name,test_types.name AS tst_name FROM test_statuses INNER JOIN tests ON tests.test_status_id = test_statuses.id
							INNER JOIN test_types ON test_types.id = tests.test_type_id
							WHERE tests.specimen_id='#{spc_id}'
						")

    if !status.blank?
      st = status.collect do |s|
          {s['tst_name'] => s['name']}
      end
      return [true, st]
    else
      return [false, '']
    end

  end

  def self.query_test_measures(test_name)
    test_name = test_name.gsub("_", " ")
    test_type_id = TestType.find_by(:name => test_name)['id']
    res = TesttypeMeasure.find_by_sql("SELECT measures.name FROM testtype_measures INNER JOIN measures
									ON measures.id = testtype_measures.measure_id
									INNER JOIN test_types ON test_types.id = testtype_measures.test_type_id
									WHERE test_types.id='#{test_type_id}'
								")

    if !res.blank?
      r = res.collect do |t|
        t['name']
      end
    else
      return  false
    end
  end

  def self.add_test(params)
    tests = params['tests']
    tracking_number = params['tracking_number']
    sql_order = OrderService.get_order_by_tracking_number_sql(tracking_number)
    return [false, 'order not available'] if sql_order == false

    spec_id = sql_order.id
    updater = params['who_updated']
    res = Test.find_by_sql("SELECT patient_id AS patient_id FROM tests WHERE specimen_id='#{spec_id}' LIMIT 1")
    patient_id = res[0]['patient_id']
    order = OrderService.retrieve_order_from_couch(sql_order.couch_id)
    return [false, 'order not available -c'] if order == "false"

    tet = []
    test_results = {}
    details = {}
    tet = order['tests']
    test_results = order['test_results']
    test_statuses = order['test_statuses']
    tests.each do |tst|
      te_id = TestType.where(name: tst).first
      return [false, 'test name not available at national lims'] if te_id.blank?

      Test.create(
        :specimen_id => spec_id,
        :test_type_id => te_id.id,
        :created_by => updater['first_name'].to_s + " " + updater['lastt_name'].to_s,
        :panel_id => '',
        :patient_id => patient_id,
        :time_created => Time.now.strftime("%Y%m%d%H%M%S"),
        :test_status_id => TestStatus.find_by_sql("SELECT id AS sts_id FROM test_statuses WHERE name='Drawn'")[0]['sts_id']
      )
      tet.push(tst)
      test_results[tst] = {
          'results': {},
                    'date_result_entered': '',
          'result_entered_by': {}
        }
      time = Time.new.strftime("%Y%m%d%H%M%S")
      details[time] = {
        "status" => "Drawn",
                "updated_by":  {
                                    :first_name => updater['first_name'],
                                    :last_name => updater['last_name'],
                                    :phone_number => updater['phone_number'],
                                    :id => updater['id_number']
                                }
      }
      test_statuses[tst] = details
    end

    order['tests'] = tet
    order['test_results'] =  test_results
    order['test_statuses'] = test_statuses

    OrderService.update_couch_order(sql_order.id, order)
    return true
  end

  def self.retrieve_test_catelog
    if File.exists?("#{Rails.root}/public/test_catelog.json")
      dat = File.read("#{Rails.root}/public/test_catelog.json")
      return JSON.parse(dat)
    else
      return false
    end
  end

  def self.retrieve_order_location
    re = Ward.find_by_sql("SELECT wards.name FROM wards")
    if !re.blank?
      r = re.collect  do |t|
        t['name']
      end
    else
      return false
    end
  end

  def self.retrieve_target_labs
    re = Site.find_by_sql("SELECT sites.name FROM sites")
    if !re.blank?
      r = re.collect  do |t|
        t['name']
      end
    else
      return false
    end
  end

  def self.get_order_test(params)
    tracking_number = params[:tracking_number]
    res1 = TestType.find_by_sql(
              "SELECT test_types.name AS test_name, test_types.id AS tes_id FROM test_types
    							INNER JOIN tests ON tests.test_type_id = test_types.id
    							INNER JOIN specimen ON tests.specimen_id = specimen.id
    							WHERE specimen.tracking_number = '#{tracking_number}'"
      )

    details = {}
    measures = {}
    ranges = []
    if !res1.blank?

      res1.each do |te|

        res = Speciman.find_by_sql("SELECT measures.name AS measure_nam, measures.id AS me_id FROM measures
    							INNER JOIN testtype_measures ON testtype_measures.measure_id = measures.id
    							INNER JOIN test_types ON test_types.id = testtype_measures.test_type_id
    							WHERE test_types.id = '#{te.tes_id}'
    						")

        if !res.blank?
          res.each do |me|
            me_ra = MeasureRange.find_by_sql("SELECT measure_ranges.alphanumeric AS alpha FROM measure_ranges
    											 WHERE measures_id ='#{me.me_id}'")
            me_ra.each do |r|
              if r.alpha.blank?
                ranges.push('free text')
              else
                ranges.push(r.alpha)
              end
            end
            measures[me.measure_nam] = ranges
            ranges = []
          end
          details[te.test_name] = measures
          measures = {}
        end
      end
    else

    end

    return details

  end

end
