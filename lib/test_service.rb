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
				update_test_status_couch(doc_id, test_status.id)

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

end
