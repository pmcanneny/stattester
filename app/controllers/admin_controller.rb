#Controller for the admin page
class AdminController < ApplicationController

	http_basic_authenticate_with :name => "admin", :password => "stat#{Time.now.month}#{Time.now.year}"

  def index
  	@companies = Company.all
    @users = User.all
  end

end
