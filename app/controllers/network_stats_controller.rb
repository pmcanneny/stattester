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
  def filter
    @company = Company.find(params[:company][:id])
    #verify that the logged-in user is authorized to see this page
    authorize_user(@company.user_id)

    @filter = StatFilter.find(@company.default_filter_id)
    @filter.update_attributes(params[:filter])

    redirect_to :action => :view, :id =>@company.id
  end

  #this is the main action of the network stats page
  def view
    @company = Company.find(params[:id])
    #verify that the logged-in user is authorized to see this page
    authorize_user(@company.user_id)

    #get the company's default stat filter
    @filter = StatFilter.find(@company.default_filter_id)

    #gather the company's trade data
	  @trade_now = TradeStat.find(@company.trade_now_id)
  	@trade_cy = TradeStat.find(@company.trade_cy_id)
  	@trade_2y = TradeStat.find(@company.trade_2y_id)
  	@trade_3y = TradeStat.find(@company.trade_3y_id)
  	@trade_4y = TradeStat.find(@company.trade_4y_id)
  	@trade_5y = TradeStat.find(@company.trade_5y_id)

    #gather the companies that the filter applies to
    companies = Company.where((@filter.region==0 ? "" : "region = #{@filter.region}"))
    @sample_size = companies.size.to_f

    #TODO: this logic can be shortened and somewhat encapsulated into a class
    #initialize all these variables to zero
    @now_revenue_category=0
    @now_asset_category=0
    @now_sales_growth=0
    @now_gross_profit_margin=0
    @now_operating_profit_margin=0
    @now_ebitda_percent=0
    @now_enterprise_multiple=0
    @now_ebitda_multiple=0
    @now_sales_multiple=0
    @now_debt_multiple=0
    @cy_revenue_category=0
    @cy_asset_category=0
    @cy_sales_growth=0
    @cy_gross_profit_margin=0
    @cy_operating_profit_margin=0
    @cy_ebitda_percent=0
    @cy_enterprise_multiple=0
    @cy_ebitda_multiple=0
    @cy_sales_multiple=0
    @cy_debt_multiple=0
    @y2_revenue_category=0
    @y2_asset_category=0
    @y2_sales_growth=0
    @y2_gross_profit_margin=0
    @y2_operating_profit_margin=0
    @y2_ebitda_percent=0
    @y2_enterprise_multiple=0
    @y2_ebitda_multiple=0
    @y2_sales_multiple=0
    @y2_debt_multiple=0
    @y3_revenue_category=0
    @y3_asset_category=0
    @y3_sales_growth=0
    @y3_gross_profit_margin=0
    @y3_operating_profit_margin=0
    @y3_ebitda_percent=0
    @y3_enterprise_multiple=0
    @y3_ebitda_multiple=0
    @y3_sales_multiple=0
    @y3_debt_multiple=0

    #add up all the values for the matching companies
    for comp in companies
      trade_now = TradeStat.find(comp.trade_now_id)
      @now_revenue_category+=(TradeStat.valid?(trade_now.revenue_category) ? trade_now.revenue_category : 0)
      @now_asset_category+=(TradeStat.valid?(trade_now.asset_category) ? trade_now.asset_category : 0)
      @now_sales_growth+=(TradeStat.valid?(trade_now.sales_growth) ? trade_now.sales_growth : 0)
      @now_gross_profit_margin+=(TradeStat.valid?(trade_now.gross_profit_margin) ? trade_now.gross_profit_margin : 0)
      @now_operating_profit_margin+=(TradeStat.valid?(trade_now.operating_profit_margin) ? trade_now.operating_profit_margin : 0)
      @now_ebitda_percent+=(TradeStat.valid?(trade_now.ebitda_percent) ? trade_now.ebitda_percent : 0)
      @now_enterprise_multiple+=(TradeStat.valid?(trade_now.enterprise_multiple) ? trade_now.enterprise_multiple : 0)
      @now_ebitda_multiple+=(TradeStat.valid?(trade_now.ebitda_multiple) ? trade_now.ebitda_multiple : 0)
      @now_sales_multiple+=(TradeStat.valid?(trade_now.sales_multiple) ? trade_now.sales_multiple : 0)
      @now_debt_multiple+=(TradeStat.valid?(trade_now.debt_multiple) ? trade_now.debt_multiple : 0)
      trade_cy = TradeStat.find(comp.trade_cy_id)
      @cy_revenue_category+=(TradeStat.valid?(trade_cy.revenue_category) ? trade_cy.revenue_category : 0)
      @cy_asset_category+=(TradeStat.valid?(trade_cy.asset_category) ? trade_cy.asset_category : 0)
      @cy_sales_growth+=(TradeStat.valid?(trade_cy.sales_growth) ? trade_cy.sales_growth : 0)
      @cy_gross_profit_margin+=(TradeStat.valid?(trade_cy.gross_profit_margin) ? trade_cy.gross_profit_margin : 0)
      @cy_operating_profit_margin+=(TradeStat.valid?(trade_cy.operating_profit_margin) ? trade_cy.operating_profit_margin : 0)
      @cy_ebitda_percent+=(TradeStat.valid?(trade_cy.ebitda_percent) ? trade_cy.ebitda_percent : 0)
      @cy_enterprise_multiple+=(TradeStat.valid?(trade_cy.enterprise_multiple) ? trade_cy.enterprise_multiple : 0)
      @cy_ebitda_multiple+=(TradeStat.valid?(trade_cy.ebitda_multiple) ? trade_cy.ebitda_multiple : 0)
      @cy_sales_multiple+=(TradeStat.valid?(trade_cy.sales_multiple) ? trade_cy.sales_multiple : 0)
      @cy_debt_multiple+=(TradeStat.valid?(trade_cy.debt_multiple) ? trade_cy.debt_multiple : 0)
      trade_2y = TradeStat.find(comp.trade_2y_id)
      @y2_revenue_category+=(TradeStat.valid?(trade_2y.revenue_category) ? trade_2y.revenue_category : 0)
      @y2_asset_category+=(TradeStat.valid?(trade_2y.asset_category) ? trade_2y.asset_category : 0)
      @y2_sales_growth+=(TradeStat.valid?(trade_2y.sales_growth) ? trade_2y.sales_growth : 0)
      @y2_gross_profit_margin+=(TradeStat.valid?(trade_2y.gross_profit_margin) ? trade_2y.gross_profit_margin : 0)
      @y2_operating_profit_margin+=(TradeStat.valid?(trade_2y.operating_profit_margin) ? trade_2y.operating_profit_margin : 0)
      @y2_ebitda_percent+=(TradeStat.valid?(trade_2y.ebitda_percent) ? trade_2y.ebitda_percent : 0)
      @y2_enterprise_multiple+=(TradeStat.valid?(trade_2y.enterprise_multiple) ? trade_2y.enterprise_multiple : 0)
      @y2_ebitda_multiple+=(TradeStat.valid?(trade_2y.ebitda_multiple) ? trade_2y.ebitda_multiple : 0)
      @y2_sales_multiple+=(TradeStat.valid?(trade_2y.sales_multiple) ? trade_2y.sales_multiple : 0)
      @y2_debt_multiple+=(TradeStat.valid?(trade_2y.debt_multiple) ? trade_2y.debt_multiple : 0)
      trade_3y = TradeStat.find(comp.trade_3y_id)
      @y3_revenue_category+=(TradeStat.valid?(trade_3y.revenue_category) ? trade_3y.revenue_category : 0)
      @y3_asset_category+=(TradeStat.valid?(trade_3y.asset_category) ? trade_3y.asset_category : 0)
      @y3_sales_growth+=(TradeStat.valid?(trade_3y.sales_growth) ? trade_3y.sales_growth : 0)
      @y3_gross_profit_margin+=(TradeStat.valid?(trade_3y.gross_profit_margin) ? trade_3y.gross_profit_margin : 0)
      @y3_operating_profit_margin+=(TradeStat.valid?(trade_3y.operating_profit_margin) ? trade_3y.operating_profit_margin : 0)
      @y3_ebitda_percent+=(TradeStat.valid?(trade_3y.ebitda_percent) ? trade_3y.ebitda_percent : 0)
      @y3_enterprise_multiple+=(TradeStat.valid?(trade_3y.enterprise_multiple) ? trade_3y.enterprise_multiple : 0)
      @y3_ebitda_multiple+=(TradeStat.valid?(trade_3y.ebitda_multiple) ? trade_3y.ebitda_multiple : 0)
      @y3_sales_multiple+=(TradeStat.valid?(trade_3y.sales_multiple) ? trade_3y.sales_multiple : 0)
      @y3_debt_multiple+=(TradeStat.valid?(trade_3y.debt_multiple) ? trade_3y.debt_multiple : 0)

  	end

  	#divide all the stats by the sample size to get the average
  	@now_revenue_category/=@sample_size
    @now_asset_category/=@sample_size
    @now_sales_growth/=@sample_size
    @now_gross_profit_margin/=@sample_size
    @now_operating_profit_margin/=@sample_size
    @now_ebitda_percent/=@sample_size
    @now_enterprise_multiple/=@sample_size
    @now_ebitda_multiple/=@sample_size
    @now_sales_multiple/=@sample_size
    @now_debt_multiple/=@sample_size
    @cy_revenue_category/=@sample_size
    @cy_asset_category/=@sample_size
    @cy_sales_growth/=@sample_size
    @cy_gross_profit_margin/=@sample_size
    @cy_operating_profit_margin/=@sample_size
    @cy_ebitda_percent/=@sample_size
    @cy_enterprise_multiple/=@sample_size
    @cy_ebitda_multiple/=@sample_size
    @cy_sales_multiple/=@sample_size
    @cy_debt_multiple/=@sample_size
    @y2_revenue_category/=@sample_size
    @y2_asset_category/=@sample_size
    @y2_sales_growth/=@sample_size
    @y2_gross_profit_margin/=@sample_size
    @y2_operating_profit_margin/=@sample_size
    @y2_ebitda_percent/=@sample_size
    @y2_enterprise_multiple/=@sample_size
    @y2_ebitda_multiple/=@sample_size
    @y2_sales_multiple/=@sample_size
    @y2_debt_multiple/=@sample_size
    @y3_revenue_category/=@sample_size
    @y3_asset_category/=@sample_size
    @y3_sales_growth/=@sample_size
    @y3_gross_profit_margin/=@sample_size
    @y3_operating_profit_margin/=@sample_size
    @y3_ebitda_percent/=@sample_size
    @y3_enterprise_multiple/=@sample_size
    @y3_ebitda_multiple/=@sample_size
    @y3_sales_multiple/=@sample_size
    @y3_debt_multiple/=@sample_size


  end


end