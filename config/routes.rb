Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  
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

end
