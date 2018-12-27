require 'test_service.rb'
require 'user_service.rb'

class API::V1::TestController < ApplicationController


	def update_test
		update_details = params
		token =  request.headers[:authorization]
		if update_details
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


	def get_test_types
		res = TestService.get_test_types
		if res[1] == true
			response = {
					status: 200,
					error: false,
					message: 'test types retrieved successfuly',
					data: {
						test_types: res[0]
					}
				}
		else
			response = {
					status: 200,
					error: false,
					message: 'no test types',
					data: {
					
					}
				}
		end

		render plain: response.to_json  and return
	end

	def add_test
		test_details = params
		token =  request.headers[:authorization]
		if test_details
			if token
				status = UserService.check_token(token)
				
					if status == true
						res = TestService.add_test(params)
						if res == true
							response = {
									status: 200,
									error: false,
									message: 'test added successfuly',
									data: {
										
									}
								}
						else
							response = {
									status: 401,
									error: true,
									message: 'test add failed',
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
					message: 'test details not provided',
					data: {
						
					}
				}
		end
		render plain: response.to_json and return

	end

	def edit_test_result
		test_details  = params
		token =  request.headers[:authorization]
		if test_details			
			if token
				status = UserService.check_token(token)
			
					if status == true
						stat = TestService.edit_test_result(params)

						if stat == true
							response = {
									status: 200,
									error: false,
									message: 'test results edited successfuly',
									data: {
										
									}
								}
						else
							response = {
									status: 401,
									error: true,
									message: 'test result edit failed',
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
					message: 'test result details not provided',
					data: {
						
					}
				}
		end
		render plain: response.to_json and return
	end


	def get_order_test
		details = TestService.get_order_test(params)
			
		render plain: details.to_json and return
	end	

end
