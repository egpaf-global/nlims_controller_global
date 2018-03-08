require 'order_service.rb'
require 'user_service.rb'
require 'tracking_number_service.rb'

class API::V1::OrderController < ApplicationController

	def create_order
	
		if params[:token]

			status = UserService.check_token(params[:token])
			if status == true
				re = TrackingNumberService.generate_tracking_number
				st = OrderService.create_order(params,re)
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
