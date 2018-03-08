require 'test_service.rb'
require 'user_service.rb'

class API::V1::TestController < ApplicationController


	def update_test
		update_details = params
		if update_details
			token = update_details[:token]
			status = UserService.check_token(token)
			if token
					if status == true
						stat = status = TestService.update_test(params)
						if stat == true
							response = {
									status: 200,
									error: false,
									message: 'test updated successfuly',
									data: {
										
									}
								}
						else
							response = {
									status: 401,
									error: true,
									message: 'update failed',
									data: {
										
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
		else
			response = {
					status: 401,
					error: true,
					message: 'update details not provided',
					data: {
						
					}
				}
			
		end
		render plain: response.to_json and return
	end


end
