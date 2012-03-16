class UserMailer < ActionMailer::Base
  default from: "noreply@stattrader.com"

  def activation_email(user)
  	@user= user
  	@url = "http://app.stattrader.com/activate/#{@user.id}/#{@user.activation_code}"
  	mail(:to => user.email, :subject => "StatTrader Activation")
  end

end
