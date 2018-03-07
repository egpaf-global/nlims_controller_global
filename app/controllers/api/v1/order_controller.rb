require 'order_service.rb'
require 'user_service.rb'

class API::V1::OrderController < ApplicationController

	def create_order
	
		if params[:token]

			status = UserService.check_token(params[:token])
			if status == true
				st = OrderService.create_order(params)
				if st == true
					response = {
						status: 200,
						error: false,
						message: 'order created successfuly',
						data: {
							tracking_number: 'XTRAK'
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
