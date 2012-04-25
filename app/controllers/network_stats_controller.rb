#the controller for the network stats page
class NetworkStatsController < ApplicationController  	
  #each of the actions in this controller require a logged-in user
  before_filter :authenticate_user
  
  #the no argument action
  #we will simply redirect to the summary sheet, as the user should never get here
  def index
    redirect_to summary_sheet_url, :notice => "Page not found."
  end
  
  #simply update the company's default filter and redirect to the view network stats page
  def filter2
    @company = Company.find(params[:company][:id])
    #verify that the logged-in user is authorized to see this page
    authorize_user(@company.user_id)

    @filter = StatFilter.find(@company.current_filter_id)
    @filter.update_attributes(params[:filter])

    redirect_to :action => :view2, :id =>@company.id
  end

  #simply update the company's default filter and redirect to the view network stats page
  def filter
    @company = Company.find(params[:company][:id])
    #verify that the logged-in user is authorized to see this page
    authorize_user(@company.user_id)

    @filter = StatFilter.find(@company.current_filter_id)
    @filter.update_attributes(params[:filter])
    @filter.name = "default"
    @filter.save

    redirect_to :action => :view, :id =>@company.id
  end

  #save a specified filter
  def save_filter
    @company = Company.find(params[:company][:id])
    #verify that the logged-in user is authorized to see this page
    authorize_user(@company.user_id)

    @filter = StatFilter.new(params[:filter])
    @filter.company_id = @company.id
    @filter.save

    @company.current_filter_id = @filter.id
    @company.save

    redirect_to :action => :view, :id =>@company.id
  end

  #load a specified filter
  def load_filter
    @company = Company.find(params[:id])
    #verify that the logged-in user is authorized 
    authorize_user(@company.user_id)

    #TODO: add default filter support

    new_filter = StatFilter.find(params[:filter][:id])
    if new_filter == nil
      flash[:notice] = "Invalid filter id"
      redirect_to :action => :view, :id =>@company.id
      return
    end
    
    @company.current_filter_id = params[:filter][:id]
    unless @company.save
      flash[:notice] = "Could not apply filter"
      redirect_to :action => :view, :id =>@company.id
      return
    end

    redirect_to :action => :view, :id =>@company.id

  end

  #this is the view of the network stats page
  def view
    @company = Company.find(params[:id])
    #verify that the logged-in user is authorized to see this page
    authorize_user(@company.user_id)

    #get the company's default stat filter
    @filter = StatFilter.find(@company.current_filter)

    #get list of filters for the company
    @filters = StatFilter.where(:company_id => @company.id)

    #gather the company's trade data
    @trade_now = TradeStat.find(@company.trade_now_id)
    @trade_cy = TradeStat.find(@company.trade_cy_id)
    @trade_2y = TradeStat.find(@company.trade_2y_id)
    @trade_3y = TradeStat.find(@company.trade_3y_id)
    @trade_4y = TradeStat.find(@company.trade_4y_id)
    @trade_5y = TradeStat.find(@company.trade_5y_id)

    #calculate and create network stats
    netstats = NetworkStat.new(@company.current_filter)

    @sample_size = netstats.total_companies
    #return if @sample_size == 0
   
    #initialize all these variables 
    #todo: change this to be not necessary
    @now_revenue_category=netstats.now_revenue_category
    @now_asset_category=netstats.now_asset_category
    @now_sales_growth=netstats.now_sales_growth
    @now_gross_profit_margin=netstats.now_gross_profit_margin
    @now_operating_profit_margin=netstats.now_operating_profit_margin
    @now_ebitda_percent=netstats.now_ebitda_percent
    @now_enterprise_multiple=netstats.now_enterprise_multiple
    @now_ebitda_multiple=netstats.now_ebitda_multiple
    @now_sales_multiple=netstats.now_sales_multiple
    @now_debt_multiple=netstats.now_debt_multiple
    @cy_revenue_category=netstats.cy_revenue_category
    @cy_asset_category=netstats.cy_asset_category
    @cy_sales_growth=netstats.cy_sales_growth
    @cy_gross_profit_margin=netstats.cy_gross_profit_margin
    @cy_operating_profit_margin=netstats.cy_operating_profit_margin
    @cy_ebitda_percent=netstats.cy_ebitda_percent
    @cy_enterprise_multiple=netstats.cy_enterprise_multiple
    @cy_ebitda_multiple=netstats.cy_ebitda_multiple
    @cy_sales_multiple=netstats.cy_sales_multiple
    @cy_debt_multiple=netstats.cy_debt_multiple
    @y2_revenue_category=netstats.y2_revenue_category
    @y2_asset_category=netstats.y2_asset_category
    @y2_sales_growth=netstats.y2_sales_growth
    @y2_gross_profit_margin=netstats.y2_gross_profit_margin
    @y2_operating_profit_margin=netstats.y2_operating_profit_margin
    @y2_ebitda_percent=netstats.y2_ebitda_percent
    @y2_enterprise_multiple=netstats.y2_enterprise_multiple
    @y2_ebitda_multiple=netstats.y2_ebitda_multiple
    @y2_sales_multiple=netstats.y2_sales_multiple
    @y2_debt_multiple=netstats.y2_debt_multiple
    @y3_revenue_category=netstats.y3_revenue_category
    @y3_asset_category=netstats.y3_asset_category
    @y3_sales_growth=netstats.y3_sales_growth
    @y3_gross_profit_margin=netstats.y3_gross_profit_margin
    @y3_operating_profit_margin=netstats.y3_operating_profit_margin
    @y3_ebitda_percent=netstats.y3_ebitda_percent
    @y3_enterprise_multiple=netstats.y3_enterprise_multiple
    @y3_ebitda_multiple=netstats.y3_ebitda_multiple
    @y3_sales_multiple=netstats.y3_sales_multiple
    @y3_debt_multiple=netstats.y3_debt_multiple

  end

end