class ApplicationController < ActionController::Base
  protect_from_forgery

  #method called as a filter to all pages that require a logged-in user
  #we make sure that the use is who they claim to be - when they log in with correct password
  #this method confirms that a user is logged in
  def authenticate_user
  	if current_user.nil?
      redirect_to root_url, :notice => "Access denied. Please log in."
  	end
  end

  #method called to confirm/deny user access to content
  # param: id  -  the user id required to have access to the content in question
  #TODO: check if this exists the current controller action - if not make it return a boolean
  def authorize_user(id)
    #check if they are who gets access to the page  
	if current_user.id != id && id != -1 # modified by Codefire
		redirect_to summary_sheet_url, :notice => "Access denied."  and  return
	end
  end

  #method to access the currently logged-in user
  #"helper_method" means this is available for use in views
  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end
  helper_method :current_user


  

end
