require 'order_service.rb'
module TestService


	def self.update_test(params)

		sql_order = OrderService.get_order_by_tracking_number_sql(params[:tracking_number])
		tracking_number = params[:tracking_number]

		if !sql_order == false 
			order_id = sql_order.id
			couch_id = sql_order.couch_id
			test_name = params[:test_name]
			
			test_id = Test.find_by_sql("SELECT tests.id FROM tests INNER JOIN test_types ON tests.test_type_id = test_types.id
							WHERE tests.specimen_id = '#{order_id}' AND test_types.name = '#{test_name}'")

			test_status = TestStatus.where(name: params[:test_status]).first
			
			if test_id
				ts = test_id[0]
				test_id = ts['id']
			
				TestStatusTrail.create(
						test_id: test_id,
						time_updated: params[:time_updated],
						test_status_id: test_status.id,
						who_updated_id: params[:who_updated]['id_number'].to_s,
						who_updated_name: params[:who_updated]['first_name'].to_s + " " + params[:who_updated]['last_name'].to_s,
						who_updated_phone_number: ''				

					)		

				tst_update = Test.find_by(:id => test_id)
				tst_update.test_status_id = test_status.id
				tst_update.save


				details = {}
				couch_test = {}
				time = Time.now.strftime("%Y%m%d%H%M%S")
				details = {
					  "status" => params[:test_status],
					  "updated_by":  {
							:first_name => params[:who_updated]['first_name'],
							:last_name => params[:who_updated]['last_name'],
							:phone_number => '',
							:id => params[:who_updated]['id_number'] 
							}
				}
				couch_test[test_name] = details

				
				
				test_results_measures = {}
				results_measure = {}
				couch_test_results = ""
				if params[:results]
					results = params[:results]
					
					results.each do |key, value|
						measure_name =  key
						result_value = value

						measure = Measure.where(name: measure_name).first

						TestResult.create(
							measure_id: measure.id,
							test_id: test_id,
							result: result_value,	
							device_name: '',						
							time_entered: time
							)
						test_results_measures[measure_name] = { 'result_value': result_value }

					end	
					
					results_measure[test_name] = test_results_measures

				end

				if !results_measure.blank?
					retr_order = OrderService.retrieve_order_from_couch(couch_id)
					couch_test_statuses = retr_order['test_statuses'][test_name]
					couch_test_statuses[time] =  details 
					retr_order['test_statuses'][test_name] =  couch_test_statuses
					
					retr_order['test_results'][test_name] = {
						'results': test_results_measures,
						'date_result_entered': '',
						'result_entered_by': {
							:first_name => params[:who_updated]['first_name'],
							:last_name => params[:who_updated]['last_name'],
							:phone_number => '95625',
							:id => params[:who_updated]['id_number'] 
						}                             
				    }
		
					OrderService.update_couch_order(couch_id,retr_order)
				else
					retr_order = OrderService.retrieve_order_from_couch(couch_id)
					couch_test_statuses = retr_order['test_statuses'][test_name]
					couch_test_statuses[time] =  details 
					retr_order['test_statuses'][test_name] =  couch_test_statuses
					OrderService.update_couch_order(couch_id,retr_order)
				end


				return true
			else
				return false

			end

		else
			return false
		end


	end

	def self.query_test_measures(test_name)
		test_name = test_name.gsub("_"," ")
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
		spec_id = sql_order.id
		updater = params['who_updated']
		res = Test.find_by_sql("SELECT visit_id AS vst_id FROM tests WHERE specimen_id='#{spec_id}' LIMIT 1")
		visit_id = res[0]['vst_id']
		order = OrderService.retrieve_order_from_couch(sql_order.couch_id)		
		tet = []
		test_results = {}
		details = {}
		tet = order['tests']
		test_results = order['test_results']
		test_statuses = order['test_statuses']
		tests.each do |tst|
			te_id = TestType.where(name: tst).first
			Test.create(
				:specimen_id => spec_id,
				:test_type_id => te_id.id,
				:visit_id => visit_id,
				:created_by => updater['first_name'].to_s + " " + updater['lastt_name'].to_s,
				:panel_id => '',
				:time_created => Time.new.strftime("$Y%m%d%H%M%S"),
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

		OrderService.update_couch_order(sql_order.id,order)
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
