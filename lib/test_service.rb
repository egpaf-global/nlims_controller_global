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
    end



    def self.edit_test_result

    end

end
