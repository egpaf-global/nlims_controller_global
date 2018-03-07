Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html


  namespace :api do
  	namespace :v1 do
  		#order routes
  		post '/create_order/:token'										 => 'order#create_order'
  		

  		#test routes
  		post '/update_test/:token'  				   					 => 'test#update_test'


  		#user routes	
  		post '/create_user/:token'						         		 =>	'user#create_user'
  		get	 '/authenticate/:username/:password' 				 		 =>	'user#authenticate_user'
  		get	 '/re_authenticate/:token' 									 =>	'user#re_authenticate_user'
  		get	 '/check_token_validity/:token' 							 =>	'user#check_token_validity'


  	end
  end

end
