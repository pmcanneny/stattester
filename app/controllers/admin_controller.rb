#Controller for the admin page
class AdminController < ApplicationController

	http_basic_authenticate_with :name => "admin", :password => "stat#{Time.now.month}#{Time.now.year}"

  def index
  	@companies = Company.all
    @users = User.all
  end

  def process_stats
  	companies = Company.all
  	for comp in companies
  		trade_now = TradeStat.find(comp.trade_now)
  		trade_cy = TradeStat.find(comp.trade_cy)
  		trade_2y = TradeStat.find(comp.trade_2y)
  		trade_3y = TradeStat.find(comp.trade_3y)
  		trade_4y = TradeStat.find(comp.trade_4y)
  		trade_5y = TradeStat.find(comp.trade_5y)

  		secure_now = SecureStat.find(comp.secure_now)
  		secure_cy = SecureStat.find(comp.secure_cy)
  		secure_2y = SecureStat.find(comp.secure_2y)
  		secure_3y = SecureStat.find(comp.secure_3y)
  		secure_4y = SecureStat.find(comp.secure_4y)
  		secure_5y = SecureStat.find(comp.secure_5y)

  		trade_now.calculate_stats!(secure_now)
			trade_cy.calculate_stats!(secure_cy)
			trade_2y.calculate_stats!(secure_2y)
			trade_3y.calculate_stats!(secure_3y)
			trade_4y.calculate_stats!(secure_4y)
			trade_5y.calculate_stats!(secure_5y)
  	end

  	redirect_to :action => :index
  end

end
