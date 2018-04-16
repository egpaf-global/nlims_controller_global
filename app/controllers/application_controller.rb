class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  skip_before_action :verify_authenticity_token  
  
  def api_version
  	
  	return 1 	
  end 

  def get_api_documentation(v)

  end

  
end
