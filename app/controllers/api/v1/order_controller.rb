require 'order_service.rb'
require 'user_service.rb'
require 'tracking_number_service.rb'
require 'thread'

class API::V1::OrderController < ApplicationController

	def create_order

				if params[:token]

						    if(!params['district'])                                      
		                        msg = "district not provided";                                      
		                    elsif(!params['health_facility_name'])
		                        msg = "health facility name not provided"
		                    elsif (!params['requesting_clinician'])
		                    	msg = 'requesting clinician not provided'
		                    elsif(!params['first_name'])
		                        msg = "patient first name not provided"
		                    elsif(!params['last_name'])
		                        msg = "patient last name not provided"
		                    elsif(!params['phone_number'])
		                        msg = "patient phone number nont provided"
		                    elsif(!params['gender'])
		                        msg = "patient gender not provided"
		                    elsif(!params['national_patient_id'])
		                        msg = "patient ID not provided"
		                    elsif(!params['sample_type'])
		                        msg = "sample type not provided"
		                    elsif(!params['tests'])
		                        msg = "tests not provided";
		                    elsif(!params['date_sample_drawn'])
		                        msg = "date for sample drawn not provided"
		                    elsif(!params['sample_priority'])
		                        msg = "sample priority level not provided"
		                    elsif(!params['target_lab'])
		                        msg = "target lab for sample not provided"
		                    elsif(!params['sample_order_location'])
		                        msg = "sample order location not provided"
		                    elsif(!params['sample_collector_first_name'])
		                        msg = "first name for person ordering not provided"
		                    elsif(!params['sample_collector_last_name'])
		                        msg = "last name for person ordering not provided"
		                    else

								status = UserService.check_token(params[:token])
								if status == true
										
										
													tracking_number = TrackingNumberService.generate_tracking_number
													st = OrderService.create_order(params, tracking_number)
													
													if st[0] == true

														response = {
															status: 200,
															error: false,
															message: 'order created successfuly',
															data: {
																tracking_number: st[1]
															}
														}
													TrackingNumberService.prepare_next_tracking_number
													end		
																						
										
								else	
									response = {
										status: 401,
										error: true,
										message: 'token expired',
										data: {
											
										}
									}
								end
							end


							if msg
								response = {
									status: 401,
									error: true,
									message: msg,
									data: {
										
									}
								}
							end
				else
					response = {
							status: 401,
							error: true,
							message: 'token not provided',
							data: {
								
							}
						}
				end
			
				
				render plain: response.to_json and return
	
	end

	def query_order_by_npid

		if params[:token] && params[:npid]
			status = UserService.check_token(params[:token])
			if status == true
				status = OrderService.query_order_by_npid(params[:npid])

				if status == false
					response = {
							status: 401,
							error: true,
							message: 'patient has Zero orders',
							data: {
								
							}
					}
				else
					
					response = {
								status: 200,
								error: false,
								message: 'orders retrieved successfuly',
								data: {
									orders: status
								}
							}

				end
				
			else
				response = {
					status: 401,
					error: true,
					message: 'token expired',
					data: {
						
					}
				}
			end


		else
			response = {
					status: 401,
					error: true,
					message: 'patient ID or token not provided',
					data: {
						
					}
			}
		end

		render plain: response.to_json and return

	end

	def samples_statistics
		stats = OrderService.samples_statistics
		if stats == false

		else

			render plain: stats.to_json and return 
		end
	end


	def samples_statistics_by_sample_type_by_test_type
		stats = OrderService.samples_statistics_by_sample_type_by_test_type('Blood', 'APTT')
		if stats == false

		else

			render plain: stats.to_json and return 
		end
	end


	def query_results_by_tracking_number

		if params[:tracking_number] && params[:token]

			status = UserService.check_token(params[:token])
			if status == true
				res = OrderService.query_results_by_tracking_number(params[:tracking_number])

				if res == false
					response = {
						status: 401,
						error: true,
						message: 'results not available',
						data: {
						}
					}
				else
					response = {
						status: 200,
						error: false,
						message: 'results retrieved successfuly',
						data: {
							tracking_number: params[:tracking_number],
							results: res
						}
					}
				end
			else	
				response = {
					status: 401,
					error: true,
					message: 'token expired',
					data: {
						
					}
				}
			end

		else
			response = {
					status: 401,
					error: true,
					message: 'tracking_number or token not provided',
					data: {
						
					}
			}
		end
	
		render plain: response.to_json and return
	end

	def query_order_by_tracking_number
			


		if  params[:tracking_number] &&  params[:token]

			status = UserService.check_token(params[:token])
			if status == true
				res = OrderService.query_order_by_tracking_number(params[:tracking_number])
				
				if res == false
					response = {
						status: 401,
						error: true,
						message: 'order not available',
						data: {
							
						}
					}
				else
					response = {
						status: 200,
						error: false,
						message: 'order retrieved',
						data: {
							tests: res[:tests],
							other: res[:gen_details]
						}
					}
				end
			else	
				response = {
					status: 401,
					error: true,
					message: 'token expired',
					data: {
						
					}
				}
			end

		else
			response = {
					status: 401,
					error: true,
					message: 'token not provided',
					data: {
						
					}
			}
		end
	
		render plain: response.to_json and return
	end

end
