require 'order_service.rb'
module TestService


	def self.update_test(params)

		sql_order = OrderService.get_order_by_tracking_number_sql(params[:tracking_number])
		

		if !sql_order == false 
			order_id = sql_order.id
			test_name = params[:test_name]
			
			test_id = Test.find_by_sql("SELECT tests.id,tests.doc_id FROM tests INNER JOIN test_types ON tests.test_type_id = test_types.id
							WHERE tests.order_id = '#{order_id}' AND test_types.name = '#{test_name}'")

			test_status = TestStatus.where(name: params[:test_status]).first
			
			if test_id
				ts = test_id[0]
				test_id = ts['id']
				doc_id =  ts['doc_id']
				
				co_status = CouchTestStatusUpdate.create(
								test_status_id: test_status.id,
								who_updated_name: params[:who_updated]['first_name'].to_s + " " + params[:who_updated]['last_name'].to_s, 
								who_updated_id: params[:who_updated]['id_number'].to_s,
								test_id: test_id
					)

				TestStatusUpdate.create(
						test_id: test_id,
						doc_id: co_status.id,
						time_updated: params[:time_updated],
						test_status_id: test_status.id,
						who_updated_id: params[:who_updated]['id_number'].to_s,
						who_updated_name: params[:who_updated]['first_name'].to_s + " " + params[:who_updated]['last_name'].to_s,				

					)
				update_test_status_sql(test_id, test_status.id)
<<<<<<< HEAD
				update_test_status_couch(doc_id, test_status.id)

			end


=======
				
				if params[:results]
					results = params[:results]
				
					results.each do |key, value|
						measure_name =  key
						result_value = value

						measure = Measure.where(name: measure_name).first

						c_test_re = CouchTestResult.create(
								measure_id: measure.id,
								test_id: test_id,
								result: result_value,						
								time_entered: ''
								)

						TestResult.create(
							measure_id: measure.id,
							test_id: test_id,
							result: result_value,
							doc_id: c_test_re.id,
							time_entered: ''
							)
						
					end	

				end
				return true
			else
				return false

			end

>>>>>>> 6dca82065ac6ac9c61e5b39195bbe0b4574ba920
		else
			return false
		end


	end


	def self.update_test_status_sql(test_id, status_id)
        Test.update(test_id,test_status_id: status_id)
    end

    def self.update_test_status_couch(doc_id, status_id)
    	raise doc_id.inspect
        Test.update(test_id,test_status_id: status_id)
    end

<<<<<<< HEAD
=======
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



    def self.edit_test_result

    end

    def self.get_order_test(params)
    	tracking_number = params[:tracking_number]
    	res1 = TestType.find_by_sql(
    						"SELECT test_types.name AS test_name, test_types.id AS tes_id FROM test_types 
    							INNER JOIN tests ON tests.test_type_id = test_types.id
    							INNER JOIN orders ON tests.order_id = orders.id
    							WHERE orders.id = '#{tracking_number}'"
    		)

    	details = {}
    	measures = {}
    	ranges = []
    	if !res1.blank?

    		res1.each do |te|
    			
    			res = Order.find_by_sql("SELECT measures.name AS measure_nam, measures.id AS me_id FROM measures 
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


>>>>>>> 6dca82065ac6ac9c61e5b39195bbe0b4574ba920
end
