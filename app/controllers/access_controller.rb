#Controller for the login page of the application
#also for controlling user access
class AccessController < ApplicationController

  layout :resolve_layout

  #The login page
  #If a user already is logged in, redirect to the Sumary Sheet
  def index
  	#check to see if the user is logged in; this might need some beefing up
    unless current_user.nil? 
      redirect_to :controller => :summary_sheet, :action => :index
    end
    @companies = Company.all
  end

  #registration page for a new user
  def register
    @user = User.new
  end

  #action of creating a new user from the registration page
  def create
    @user = User.new(params[:user])
    if @user.save
      redirect_to :action => :please_activate, :id => @user.id  #,:notice => "Account Created. Please activate via email confirmation."
    else
      render "register"
    end
  end

  #The login action
  def login
  	user = User.find_by_email(params[:email])

   	if user && user.authenticate(params[:password])
      if user.activated
    	 session[:user_id] = user.id
    	 redirect_to root_url, :notice => "Logged in!"
      else
        #user has not activated account via email yet
        redirect_to :action => :please_activate, :id => user.id
      end
  	else
    	# flash.now.alert = "Invalid email or password"
    	# render "index"
    	redirect_to root_url, :notice => "Invalid email or password."
  	end
  end

  #The logout action
  def logout
  	session[:user_id] = nil
  	redirect_to root_url, :notice => "Logged out!"
  end
  
  #user has not activated via email yet
  def please_activate
    @user = User.find(params[:id])
    if @user.nil?
      redirect_to root_url, :notice => "Access Denied."
    elsif @user.activated
      redirect_to root_url, :notice => "Email already verified."
    else
      UserMailer.activation_email(@user).deliver
    end
  end

  def activate
    user = User.find(params[:id])
    code = params[:code]
    if user.nil? or code.nil?
      redirect_to root_url, :notice => "Invalid Request"
    elsif user.activated
      redirect_to root_url, :notice => "Account has alread been activated"
    else
      if user.activate(code)
        #success
        redirect_to root_url, :notice => "Account Activated!"
      else
        #failure
        redirect_to root_url, :notice => "Invalid activation code."
      end
    end
  end

  # #temporary XML export test
  # def exportcompany
  #   @company = Company.find(params[:id])
  #   render "exportcompany.xml.erb" #=> @company.to_xml
  # end

  def debug
    @companies = Company.all
    @users = User.all
  end


  private 

  #conditional to determine layout
  def resolve_layout
    case action_name
    when "please_activate"
      nil
    else
      "login"
    end
  end


end
