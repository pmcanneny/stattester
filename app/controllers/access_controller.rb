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
  rescue ActiveRecord::RecordNotFound
    redirect_to root_url, :notice => "User not found."
  end

  #page for "forgot your password?"
  def forgot_password
  end

  #send user the initial "forgot password" email
  def forgot_password_email
    @user = User.find_by_email(params[:email])    
    if @user.nil?
      redirect_to :action => :forgot_password, :notice => "Account not found."
    elsif !(@user.last_password_email.nil?) and (@user.last_password_email+5.minutes > Time.now)
        redirect_to root_url, :notice => "Email has been sent recently. Please wait a few minutes for additional password requests."
    else
      @user.generate_token(:reset_password_code)
      @user.last_password_email = Time.now
      @user.reset_password_expires = Time.now + 2.hours
      @user.save
      UserMailer.forgot_password_email(@user).deliver    
    end
  rescue ActiveRecord::RecordNotFound
    redirect_to root_url, :notice => "User not found."
  end

  #the action for the reset_password page
  #todo: make code expire
  def reset_password
    @user = User.find_by_reset_password_code(params[:code])
    if @user.nil?
      redirect_to root_url, :notice => "Access Denied."
    end
  rescue ActiveRecord::RecordNotFound
    redirect_to root_url, :notice => "Invalid Password Reset Code."
  end

  #update the users password for the reset_password page
  def update_password
    @user = User.find_by_reset_password_code(params[:user][:reset_password_code])
    #set reset code to nil incase of successful update
    if @user.update_attributes(:password => params[:user][:password], :password_confirmation => params[:user][:password_confirmation], :reset_password_code => nil)
      flash[:notice] = "Password Updated!"
      redirect_to root_url
    else
      flash[:notice] = "Passwords must be greater than 4 characters and must match. Please try again."
      redirect_to :action => 'reset_password', :code => params[:user][:reset_password_code]
    end
  end



  #attempt to activate specified user account with given activation code
  def activate
    user = User.find_by_activation_code(params[:code])
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
  rescue ActiveRecord::RecordNotFound
    redirect_to root_url, :notice => "User not found."
  end

  # #temporary XML export test
  # def exportcompany
  #   @company = Company.find(params[:id])
  #   render "exportcompany.xml.erb" #=> @company.to_xml
  # end

  private 

  #conditional to determine layout
  def resolve_layout
    case action_name
    when "please_activate"
      "short_message"
    when "forgot_password_email"
      "short_message"
    when "reset_password_email"
      "short_message"
    else
      "login"
    end
  end


end
