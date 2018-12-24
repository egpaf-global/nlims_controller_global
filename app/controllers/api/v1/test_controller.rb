require 'test_service.rb'
require 'user_service.rb'

class API::V1::TestController < ApplicationController


	def update_test
		update_details = params
		if update_details
			
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
					message: 'update details not provided',
					data: {
						
					}
				}
			
		end
		render plain: response.to_json and return
	end

	def retrieve_test_catelog

		dat = TestService.retrieve_test_catelog
		if dat == false
			response = {
							status: 401,
							error: true,
							message: 'test catelog not available',
							data: {
										
							}
						}
		else
			response = {
							status: 200,
							error: false,
							message: 'test added successfuly',
							data: dat
						}
		end


		render plain: response.to_json and return
	end

	def add_test
		test_details = params
		if test_details
			
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
					message: 'test details not provided',
					data: {
						
					}
				}
		end
		render plain: response.to_json and return

	end

	def edit_test_result
		test_details  = params
	
		if test_details			
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
					message: 'test result details not provided',
					data: {
						
					}
				}
		end
		render plain: response.to_json and return
	end

end
