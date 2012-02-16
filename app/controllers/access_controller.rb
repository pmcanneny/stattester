#Controller for the login page of the application
#also for controlling user access
class AccessController < ApplicationController

  layout 'login'

  #The login page
  #If a user already is logged in, redirect to the Sumary Sheet
  def index
  	#check to see if the user is logged in; this might need some beefing up
    unless current_user.nil? 
      redirect_to :controller => :summary_sheet, :action => :index
    end
  end

  #registration page for a new user
  def register
    @user = User.new
  end

  #action of creating a new user from the registration page
  def create
    @user = User.new(params[:user])
    if @user.save
      redirect_to root_url, :notice => "Signed up!"
    else
      render "register"
    end
  end

  #The login action
  def login
  	user = User.find_by_email(params[:email])
   	  if user && user.authenticate(params[:password])
    	session[:user_id] = user.id
    	redirect_to root_url, :notice => "Logged in!"
  	  else
    	# flash.now.alert = "Invalid email or password"
    	# render "index"
    	redirect_to root_url, :notice => "Invalid email or password"
  	end
  end

  #The logout action
  def logout
  	session[:user_id] = nil
  	redirect_to root_url, :notice => "Logged out!"
  end


end
