Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

<<<<<<< HEAD
  
  get '/api'  => 'api#index'

  post 'api/:version_number/create_order/:token' 						=> 'api#create_order'
  get 'api/:version_number/create_order/:token' 						=> 'api#create_order'
  post 'api/:version_number/update_order/:token'					 	=> 'api#update_order'
  get  'api/:version_number/query_order/:tracking_number/:token'   	=> 'api#query_order'
  post 'api/:version_number/query_orders/:start_date/:end_date/:token' => 'api#query_orders_by_date'
 
  post 'api/:version_number/query_orders/:npid/:token' 				=> 'api#query_orders_by_npid'


  post 'api/:version_number/create_user/:token' 						=> 'api#create_user'
  get 'api/:version_number/authenticate/:username/:password' 			=> 'api#authenticate_user'
  get 'api/:version_number/check_token_validity/:token' 				=> 'api#check_token_validity'
  put 'api/:version_number/re_authenticate/:username/:password' 		=> 'api#re_authenticate'
  post 'api/:version_number/update_test/:token'       => 'api#update_test'


#  root 'home#index'
=======

  namespace :api do
  	namespace :v1 do
  		#order routes
  		post '/create_order/:token'										 => 'order#create_order'
  		get  '/query_results_by_tracking_number/:tracking_number/:token' => 'order#query_results_by_tracking_number'
  		get '/query_order_by_tracking_number/:tracking_number/:token'	 => 'order#query_order_by_tracking_number'
      get '/query_order_by_npid/:npid/:token' => 'order#query_order_by_npid'
		  		

  		#test routes
  		post '/update_test/:token'  				   					 => 'test#update_test'
      post '/add_test/:token'                           => 'test#add_test'
      put  '/edit_test_result/:token'                  => 'test#edit_test_result'
      get  '/get_order_test/:tracking_number'          => 'test#get_order_test'
 

  		#user routes	
  		post '/create_user/:token'						         		 =>	'user#create_user'
  		get	 '/authenticate/:username/:password' 				 		 =>	'user#authenticate_user'
  		get	 '/re_authenticate/:username/:password'						 =>	'user#re_authenticate'
  		get	 '/check_token_validity/:token' 							 =>	'user#check_token_validity'


  	end
  end
>>>>>>> 6dca82065ac6ac9c61e5b39195bbe0b4574ba920

end
