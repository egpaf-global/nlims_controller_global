require 'order_service.rb'
require 'user_service.rb'
require 'tracking_number_service.rb'
require 'thread'

class API::V1::OrderController < ApplicationController

	def create_order
	   
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
		                        msg = "patient phone number not provided"
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
							elsif(!params['sample_status'])
								msg = "sample status not provided"
		                    elsif(!params['sample_priority'])
		                        msg = "sample priority level not provided"
		                    elsif(!params['target_lab'])
		                        msg = "target lab for sample not provided"
		                    elsif(!params['order_location'])
		                        msg = "sample order location not provided"
		                    elsif(!params['who_order_test_first_name'])
		                        msg = "first name for person ordering not provided"
		                    elsif(!params['who_order_test_last_name'])
		                        msg = "last name for person ordering not provided"
		                    else
								order_availability = false
									if (params['tracking_number'] && !params['tracking_number'].blank?)
                                        tracking_number = params['tracking_number']
										order_availability = OrderService.check_order(tracking_number)
										
										if order_availability == true											
											response = {
												status: 200,
												error: false,
												message: 'order already available',
												data: {
														tracking_number: tracking_number
													}
											}			
											render plain: response.to_json and return			
										end
                                    else
                                        tracking_number = TrackingNumberService.generate_tracking_number
                                    end
														
									st = OrderService.create_order(params, tracking_number)
												
									if st[0] == true

										response = {
												status: 200,
												error: false,
												message: 'order created successfuly',
												data: {
														tracking_number: st[1],
														couch_id: st[2]
													}
											}
										TrackingNumberService.prepare_next_tracking_number
									else
									      response = {
                                                       					status: 401,
                                                        				error: true,
                                                        				message: st[1],
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
				
				render plain: response.to_json and return	
	end
	
	def check_if_dispatched
	
		if !params[:tracking_number].blank?
			res = OrderService.check_if_dispatched(params[:tracking_number])
			if res == false
				response = {
								status: 200,
								error: false,
								message: 'sample not dispatced',
								data: {	}
							}

			else
				response = {
							status: 401,
							error: true,
							message: 'sample already dispatched',
							data: {
								
							}
					}
			end
		else
			response = {
							status: 401,
							error: true,
							message: 'tracking number not provided',
							data: {
								
							}
					}
		end

		render plain: response.to_json  and return
	end
	
	def retrieve_undispatched_samples		
		facilities = params[:facilities]
		
		if facilities.blank?
			msg = "please provide facilities in order to have undispatched samples"
		elsif !facilities.kind_of?(Array)
			msg = "data parameter format is incorrect, Array format is accepted only"
		elsif facilities.length > 5
			msg = "can not request undispatcahed samples for more than FIVE facilities"
		else

			res =OrderService.retrieve_undispatched_samples(facilities)
			
			if res[0] == true
					response = {
								status: 200,
								error: false,
								message: 'undispatching samples successfuly retrieved',
								data: res[1]
							}
			else
				response = {
							status: 401,
							error: true,
							message: "error",
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

		render plain: response.to_json  and return
	end

	def dispatch_sample
		if params[:tracking_number] && params[:dispatcher] && params[:date_dispatcher] && params[:dispatcher_type]
			dispatcher_type_id = SpecimenDispatchType.find_by(name: params[:dispatcher_type])
            
			if !dispatcher_type_id.id.blank?
				res = OrderService.check_if_dispatched(params[:tracking_number],dispatcher_type_id.id)
				
				if res == false
					status = OrderService.dispatch_sample(params[:tracking_number],params[:dispatcher],params[:date_dispatcher],dispatcher_type_id.id)
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
									message: 'dispatching successfuly done',
									data: {
										orders: status
									}
								}

					end
				else
					msg = "sample already dispatched from the given location (dispatch type)"
				end
			else
				msg = "dispatcher type provided not recognised"
			end
		else
			response = {
					status: 401,
					error: true,
					message: 'tracking number or dispatch details not provided',
					data: {
						
					}
			}
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

		render plain: response.to_json and return
	end


	def request_order

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
					msg = "patient phone number not provided"
				elsif(!params['gender'])
					msg = "patient gender not provided"
				elsif(!params['national_patient_id'])
					msg = "patient ID not provided"
				elsif(!params['tests'])
					msg = "tests not provided";
				elsif(!params['date_sample_drawn'])
					msg = "date for sample drawn not provided"
				elsif(!params['sample_priority'])
					msg = "sample priority level not provided"
				elsif(!params['order_location'])
					msg = "sample order location not provided"
				elsif(!params['who_order_test_first_name'])
					msg = "first name for person ordering not provided"
				elsif(!params['who_order_test_last_name'])
					msg = "last name for person ordering not provided"
				else
					order_availability = false
					if (params['tracking_number'])
						tracking_number = params['tracking_number']
						order_availability = OrderService.check_order(tracking_number)
						
						if order_availability == true											
							response = {
								status: 200,
								error: false,
								message: 'order already available',
								data: {
										tracking_number: tracking_number
									}
							}			
							render plain: response.to_json and return			
						end
					else
						tracking_number = TrackingNumberService.generate_tracking_number
					end								
						st = OrderService.request_order(params, tracking_number)
									
						if st[0] == true

							response = {
									status: 200,
									error: false,
									message: 'order created successfuly',
									data: {
											tracking_number: st[1],
											couch_id: st[2]
										}
								}
							TrackingNumberService.prepare_next_tracking_number
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

		render plain: response.to_json and return	

	end


	def query_requested_order_by_npid

		if params[:npid]
				status = OrderService.query_requested_order_by_npid(params[:npid])
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
					message: 'patient ID not provided',
					data: {
						
					}
			}
		end

		render plain: response.to_json and return

	end

	def query_order_by_npid

		if params[:npid]
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
					message: 'patient ID not provided',
					data: {
						
					}
			}
		end

		render plain: response.to_json and return

	end


	def query_results_by_npid

		if params[:npid]
				res = OrderService.query_results_by_npid(params[:npid])

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
							results: res
						}
					}
				end		

		else
			response = {
					status: 401,
					error: true,
					message: 'npid not provided',
					data: {
						
					}
			}
		end
	
		render plain: response.to_json and return
	end

	def update_order
		if params['tracking_number']  && params['who_updated']	&& params['status']
			order_availability = OrderService.check_order(params['tracking_number'])
										
			if order_availability == false											
				response = {
					status: 200,
					error: false,
					message: 'order not available',
						data: {
								tracking_number: params['tracking_number']
							}
						}			
				render plain: response.to_json and return			
			end

	           status = OrderService.update_order(params)
		   if status[0] == true
			response = {
						status: 200,
						error: false,
						message: 'order updated successfuly',
						data: {
						}
					}
		   else
			
			response = {
                                                status: 401,
                                                error: false,
                                                message: status[1],
                                                data: {
                                                }
                                        }
		   end
		else
			response = {
					status: 401,
					error: true,
					message: 'missing parameter, please check',
					data: {
						
					}
			}
		end		
		render plain: response.to_json and return
	end

	def query_results_by_tracking_number
		
		if params[:tracking_number]

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
					message: 'tracking_number not provided',
					data: {
						
					}
			}
		end
	
		render plain: response.to_json and return
	end

	def query_order_by_tracking_number
		if  params[:tracking_number]

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
					message: 'tracking number not provided',
					data: {
						
					}
			}
		end
	
		render plain: response.to_json and return
	end

end
