require 'order_service.rb'
module TestService


	def self.update_test(params)

		sql_order = OrderService.get_order_by_tracking_number_sql(params[:tracking_number])
		tracking_number = params[:tracking_number]

		if !sql_order == false 
			order_id = sql_order.id
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
						who_updated_phone_number: '920202'				

					)
		

				details = {}
				couch_test = {}
				time = Time.now.strftime("%Y%m%d%m%s%h")
				details = {
					  "status" => params[:test_status],
					  "updated_by":  {
							:first_name => params[:who_updated]['first_name'],
							:last_name => params[:who_updated]['last_name'],
							:phone_number => '95625',
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
							time_entered: '2018-09-21 04:38:02'
							)
						test_results_measures[measure_name] = { 'result_value': result_value }

					end	
					
					results_measure[test_name] = test_results_measures

				end

				if !results_measure.blank?
					retr_order = OrderService.retrieve_order_from_couch(tracking_number)
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
		
					OrderService.update_couch_order(tracking_number,retr_order)
				else
					retr_order = OrderService.retrieve_order_from_couch(tracking_number)
					couch_test_statuses = retr_order['test_statuses'][test_name]
					couch_test_statuses[time] =  details 
					retr_order['test_statuses'][test_name] =  couch_test_statuses
					OrderService.update_couch_order(tracking_number,retr_order)
				end


				return true
			else
				return false

			end

		else
			return false
		end


	end

    def self.add_test(params)

    	te_id = TestType.where(name: params[:test_name]).first
    
    	c_tes = CouchTest.create(
    			order_id: params[:tracking_number],
    			test_type_id: te_id.id,
    			time_created: Date.today.strftime("%a %b %d %Y"),
    			test_status_id: 2,
    		)

    	Test.create(
    			order_id: params[:tracking_number],
    			test_type_id: te_id.id,
    			time_created: Date.today.strftime("%a %b %d %Y"),
    			doc_id: c_tes.id,
    			test_status_id: 2,

    		)

        return true
    end

    def self.get_order_test(params)
    	tracking_number = params[:tracking_number]
    	res1 = TestType.find_by_sql(
    						"SELECT test_types.name AS test_name, test_types.id AS tes_id FROM test_types 
    							INNER JOIN tests ON tests.test_type_id = test_types.id
    							INNER JOIN specimen ON tests.specimen_id = specimen.id
    							WHERE specimen.id = '#{tracking_number}'"
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
