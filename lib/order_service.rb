
module  OrderService

	def self.create_order(params)
		ActiveRecord::Base.transaction do 

			npid = params[:national_patient_id]
			patient_obj = Patient.where(patient_id: npid)

			patient_obj = patient_obj.first unless patient_obj.blank?
				if patient_obj.blank?
					pat = CouchPatient.create()
					patient_obj.create(patient_id: npid, name: '')
				end

                  #obtaining order details posted by client

			sample_type = SpecimenType.where(name: params[:sample_type]).first
                  sample_collector_name = params[:sample_collector_first_name] + " " + params[:sample_collector_last_name]
                  sample_collector_phone_number = params[:sample_collector_phone_number]
                  sample_collector_id = params[:sample_collector_id]
                  sample_order_location = params[:sample_order_location]
                  requesting_clinician = params[:requesting_clinician]
                  date_sample_drawn = params[:date_sample_drawn]
                  date_created = params[:date_created]
                  sample_priority = params[:sample_priority]
                  target_lab = params[:target_lab]
                  art_start_date = params[:art_start_date]
                  health_facility_name = params[:health_facility_name]
                  health_facility_district = params[:health_facility_district]
                  specimen_status = SpecimenStatus.where(name: 'specimen_accepted').first

                  sample_collector = {
                                    id: sample_collector_id,
                                    first_name: sample_collector_name.split(" ")[0],
                                    last_name: sample_collector_name.split(" ")[1],
                                    phone_number: sample_collector_phone_number
                  }

			c_order  = CouchOrder.create(
                                                tracking_number: "2222222",
                                                date_created: date_created,
                                                priority: sample_priority,
                                                specimen_status: specimen_status.id,
                                                sample_collector: sample_collector,
                                                patient_id: npid, 
                                                sample_type: sample_type.id,
                                                target_lab: target_lab,
                                                art_start_date: art_start_date,
                                                health_facility: health_facility_name,
                                                ward_or_location: sample_order_location,
                                                requested_by: requesting_clinician,
                                                date_sample_drawn: date_sample_drawn,
                                                date_created: date_created,
                                                health_facility_district: health_facility_district
                              )

                  ward = Ward.where(name: sample_order_location)

			sq_order = Order.create(
                                                doc_id: c_order.id, 
                                                tracking_number: '22222',
                                                patient_id: '11',
                                                sample_type_id: sample_type.id,
                                                specimen_status_id: specimen_status.id,
                                                date_created: date_created,
                                                priority: sample_priority,
                                                sample_drawn_by_id: sample_collector_id,
                                                sample_drawn_by_name: sample_collector_name,
                                                sample_drawn_by_phone_number: sample_collector_phone_number,
                                                target_lab: target_lab,
                                                art_start_date: art_start_date,
                                                health_facility: health_facility_name,
                                                ward_or_location_id:  ward.name,
                                                requested_by: requesting_clinician
                              )



                 tests = TestType.where(name: params[:tests])

			(tests || []).each do |test| 
             
	 			t = CouchTest.create(   order_id: c_order.id, 
                                                test_type_id: test.id, 
                                                time_created: date_created,
                                                test_status_id: 'Drawn'
                                          )

	 			Test.create(
                                    doc_id: t.id,
                                    order_id: sq_order.id,
                                    test_type_id: test.id,
                                    time_created: date_created,
                                    test_status_id: 'Drawn'
                              )
			end


		end			
            return true
	end


      def self.get_order_by_tracking_number_sql(tracking_number)
          details =   Order.where(tracking_number: tracking_number).first
            if details
                  return details
            else
                  return false
            end
      end

      


end







