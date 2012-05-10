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
    @trade_now = TradeStat.find(@company.trade_now)
    @trade_cy = TradeStat.find(@company.trade_cy)
    @trade_2y = TradeStat.find(@company.trade_2y)
    @trade_3y = TradeStat.find(@company.trade_3y)
    @trade_4y = TradeStat.find(@company.trade_4y)
    @trade_5y = TradeStat.find(@company.trade_5y)

    #calculate and create network stats
    netstats = NetworkStat.new(@company.current_filter)

    @sample_size = netstats.total_companies
    @public_companies = netstats.public_companies
    @private_companies = netstats.private_companies
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

    #logic for SIC codes
    @sic_1digit = SIC.get_divisions

    respond_to do |format|
      format.html
      format.xml { send_data @company.stattrader_xml, content_type: 'text/xml', :filename => "#{@company.name}-StatTrader.xml" }
      format.xls { send_data @company.networkstats_xls(netstats).string, content_type: 'application/vnd.ms-excel', :filename => "#{@company.name}.xls" }
    end

  end

  #filling in the SIC dropdowns
  def fill_in_sics
    @sic_2digit = SIC.get_children(params[:id])
    @id = params[:id]    
    respond_to do |format|            
        format.js
    end
  end
  #filling in the SIC dropdowns
  def fill_in_sics_3digit
    @sic_3digit = SIC.get_children(params[:id])
    @id = params[:id]    
    respond_to do |format|            
        format.js
    end
  end
  #filling in the SIC dropdowns
  def fill_in_sics_4digit
    @sic_4digit = SIC.get_children(params[:id])
    @id = params[:id]    
    respond_to do |format|            
        format.js
    end
  end

  #show a list of all public companies in the current filter
  def show_publics
    @company = Company.find(params[:id])
    #verify that the logged-in user is authorized to see this page
    authorize_user(@company.user_id)

    #get the company's default stat filter
    @filter = StatFilter.find(@company.current_filter)

    ####################################################
    quality_filter = Array.new
    quality_filter.push(1) if @filter.accounts_audit
    quality_filter.push(2) if @filter.accounts_review
    quality_filter.push(3) if @filter.accounts_mgt

    tradestats = TradeStat.where(
      @filter.revenue_low.to_f==0 ? "" : "revenue_category >= #{@filter.revenue_low}").where(
      @filter.revenue_high.to_f==0 ? "" : "revenue_category <= #{@filter.revenue_high}").where(
      @filter.asset_low.to_f==0 ? "" : "asset_category >= #{@filter.asset_low}").where(
      @filter.asset_high.to_f==0 ? "" : "asset_category <= #{@filter.asset_high}").where(
      :quality => quality_filter)

    temp = tradestats.all(:select => 'DISTINCT company_id')
    company_ids1 = temp.map{|temp| temp.company_id}

    user_types = Array.new
    user_types.push(1) if @filter.user_cpa
    user_types.push(2) if @filter.user_investment_banker
    user_types.push(3) if @filter.user_business_broker
    user_types.push(4) if @filter.user_business_appraiser
    user_types.push(5) if @filter.user_commercial_lender
    user_types.push(6) if @filter.user_private_investor
    user_types.push(7) if @filter.user_public_investor
    user_types.push(8) if @filter.user_financial_pro
    user_types.push(9) if @filter.user_executive
    user_types.push(10) if @filter.user_attorney
    user_types.push(11) if @filter.user_consultant
    user_types.push(12) if @filter.user_not_classified
    users = User.where(:subtype => user_types)    

    temp = users.all(:select => :id)
    user_ids1 = temp.map{|temp| temp.id}
    user_ids1.push(-1) if @filter.user_stattrader 

    #todo: Also filter out non-network valid companies    

    unless @filter.sic_parent.nil? or @filter.sic_parent.empty? or @filter.sic_parent == ""
      sics = SIC.get_sics(@filter.sic_parent)
      companies = Company.where(:sic => sics).where(:id => company_ids1).where(:user_id => user_ids1)
    else
      companies = Company.where(:id => company_ids1).where(:user_id => user_ids1)
    end

    combination_filter = Array.new
    combination_filter.push(1) if @filter.entities_combination
    combination_filter.push(2) if @filter.entities_not_combination

    ownership_filter = Array.new
    ownership_filter.push(1) 

    #gather the companies that the filter applies to
    companies = companies.where(
      @filter.region.to_f==0 ? "" : "region = #{@filter.region}").where(
      :combination => combination_filter).where(
      :ownership => ownership_filter)

    @companies = companies
    render :layout => 'public_company'
  end

  #show a table containing private company involvement stats
  def private_stats
    @company = Company.find(params[:id])
    #verify that the logged-in user is authorized to see this page
    authorize_user(@company.user_id)

    #get the company's default stat filter
    @filter = StatFilter.find(@company.current_filter)

    ####################################################
    quality_filter = Array.new
    quality_filter.push(1) if @filter.accounts_audit
    quality_filter.push(2) if @filter.accounts_review
    quality_filter.push(3) if @filter.accounts_mgt

    tradestats = TradeStat.where(
      @filter.revenue_low.to_f==0 ? "" : "revenue_category >= #{@filter.revenue_low}").where(
      @filter.revenue_high.to_f==0 ? "" : "revenue_category <= #{@filter.revenue_high}").where(
      @filter.asset_low.to_f==0 ? "" : "asset_category >= #{@filter.asset_low}").where(
      @filter.asset_high.to_f==0 ? "" : "asset_category <= #{@filter.asset_high}").where(
      :quality => quality_filter)

    temp = tradestats.all(:select => 'DISTINCT company_id')
    company_ids1 = temp.map{|temp| temp.company_id}

    user_types = Array.new
    user_types.push(1) if @filter.user_cpa
    user_types.push(2) if @filter.user_investment_banker
    user_types.push(3) if @filter.user_business_broker
    user_types.push(4) if @filter.user_business_appraiser
    user_types.push(5) if @filter.user_commercial_lender
    user_types.push(6) if @filter.user_private_investor
    user_types.push(7) if @filter.user_public_investor
    user_types.push(8) if @filter.user_financial_pro
    user_types.push(9) if @filter.user_executive
    user_types.push(10) if @filter.user_attorney
    user_types.push(11) if @filter.user_consultant
    user_types.push(12) if @filter.user_not_classified
    users = User.where(:subtype => user_types)    

    temp = users.all(:select => :id)
    user_ids1 = temp.map{|temp| temp.id}
    user_ids1.push(-1) if @filter.user_stattrader 

    #todo: Also filter out non-network valid companies    

    unless @filter.sic_parent.nil? or @filter.sic_parent.empty? or @filter.sic_parent == ""
      sics = SIC.get_sics(@filter.sic_parent)
      companies = Company.where(:sic => sics).where(:id => company_ids1).where(:user_id => user_ids1)
    else
      companies = Company.where(:id => company_ids1).where(:user_id => user_ids1)
    end

    combination_filter = Array.new
    combination_filter.push(1) if @filter.entities_combination
    combination_filter.push(2) if @filter.entities_not_combination

    ownership_filter = Array.new
    ownership_filter.push(2)
    ownership_filter.push(3)
    ownership_filter.push(4)

    #gather the companies that the filter applies to
    companies = companies.where(
      @filter.region.to_f==0 ? "" : "region = #{@filter.region}").where(
      :combination => combination_filter).where(
      :ownership => ownership_filter)

    temp = companies.all(:select => 'DISTINCT user_id')
    user_ids1 = temp.map{|temp| temp.user_id}

    
    @licensee_m = User.where(:id => user_ids1).where(:subtype => [1,2,3])
    @licensee_m = @licensee_m.map{|i| i.id}
    @licensee_c = companies.where(:user_id => @licensee_m).size.to_i
    @licensee_m = @licensee_m.size.to_i
    @cpa_m = User.where(:id => user_ids1).where(:subtype => 1)
    @cpa_m = @cpa_m.map{|i| i.id}
    @cpa_c = companies.where(:user_id => @cpa_m).size.to_i
    @cpa_m = @cpa_m.size.to_i
    @banker_m = User.where(:id => user_ids1).where(:subtype => 2)
    @banker_m = @banker_m.map{|i| i.id}
    @banker_c = companies.where(:user_id => @banker_m).size.to_i
    @banker_m = @banker_m.size.to_i
    @broker_m = User.where(:id => user_ids1).where(:subtype => 3)
    @broker_m = @broker_m.map{|i| i.id}
    @broker_c = companies.where(:user_id => @broker_m).size.to_i
    @broker_m = @broker_m.size.to_i

    @commercial_m = User.where(:id => user_ids1).where(:subtype => [8,9])
    @commercial_m = @commercial_m.map{|i| i.id}
    @commercial_c = companies.where(:user_id => @commercial_m).size.to_i
    @commercial_m = @commercial_m.size.to_i
    @financialpro_m = User.where(:id => user_ids1).where(:subtype => 8)
    @financialpro_m = @financialpro_m.map{|i| i.id}
    @financialpro_c = companies.where(:user_id => @financialpro_m).size.to_i
    @financialpro_m = @financialpro_m.size.to_i
    @executive_m = User.where(:id => user_ids1).where(:subtype => 9)
    @executive_m = @executive_m.map{|i| i.id}
    @executive_c = companies.where(:user_id => @executive_m).size.to_i
    @executive_m = @executive_m.size.to_i
    
    @financial_m = User.where(:id => user_ids1).where(:subtype => [4,5,6,7])
    @financial_m = @financial_m.map{|i| i.id}
    @financial_c = companies.where(:user_id => @financial_m).size.to_i
    @financial_m = @financial_m.size.to_i
    @appraiser_m = User.where(:id => user_ids1).where(:subtype => 4)
    @appraiser_m = @appraiser_m.map{|i| i.id}
    @appraiser_c = companies.where(:user_id => @appraiser_m).size.to_i
    @appraiser_m = @appraiser_m.size.to_i
    @lender_m = User.where(:id => user_ids1).where(:subtype => 5)
    @lender_m = @lender_m.map{|i| i.id}
    @lender_c = companies.where(:user_id => @lender_m).size.to_i
    @lender_m = @lender_m.size.to_i
    @priv_investor_m = User.where(:id => user_ids1).where(:subtype => 6)
    @priv_investor_m = @priv_investor_m.map{|i| i.id}
    @priv_investor_c = companies.where(:user_id => @priv_investor_m).size.to_i
    @priv_investor_m = @priv_investor_m.size.to_i
    @pub_investor_m = User.where(:id => user_ids1).where(:subtype => 7)
    @pub_investor_m = @pub_investor_m.map{|i| i.id}
    @pub_investor_c = companies.where(:user_id => @pub_investor_m).size.to_i
    @pub_investor_m = @pub_investor_m.size.to_i

    @analyst_m = User.where(:id => user_ids1).where(:subtype => [10,11,12])
    @analyst_m = @analyst_m.map{|i| i.id}
    @analyst_c = companies.where(:user_id => @analyst_m).size.to_i
    @analyst_m = @analyst_m.size.to_i
    @attorney_m = User.where(:id => user_ids1).where(:subtype => 10)
    @attorney_m = @attorney_m.map{|i| i.id}
    @attorney_c = companies.where(:user_id => @attorney_m).size.to_i
    @attorney_m = @attorney_m.size.to_i
    @consultant_m = User.where(:id => user_ids1).where(:subtype => 11)
    @consultant_m = @consultant_m.map{|i| i.id}
    @consultant_c = companies.where(:user_id => @consultant_m).size.to_i
    @consultant_m = @consultant_m.size.to_i
    @not_classified_m = User.where(:id => user_ids1).where(:subtype => 12)
    @not_classified_m = @not_classified_m.map{|i| i.id}
    @not_classified_c = companies.where(:user_id => @not_classified_m).size.to_i
    @not_classified_m = @not_classified_m.size.to_i
    
    render :layout => 'public_company'
  end


end