class UserMailer < ActionMailer::Base
  default from: "newuser@stattrader.com"

  def activation_email(user)
  	@user= user
  	@url = "http://app.stattrader.com/activate/#{@user.activation_code}"
  	mail(:to => user.email, :subject => "StatTrader Activation")
  end

  def forgot_password_email(user)
	@user=user
  	@url = "http://app.stattrader.com/reset_password/#{@user.reset_password_code}"
  	mail(:to => user.email, :subject => "StatTrader - Forgot Your Password?")
  end

  def new_password_email(user, new_password)
  	@user=user
  	@new_password=new_password
  	mail(:to => user.email, :subject => "StatTrader - New Password")
  end

end
