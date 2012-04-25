#this is a class for temporarily storing the calculated network stats for a particular query
#this is not really a model but will somewhat function as one in the controllers
#this does not interact with the database in any way
class NetworkStat

	attr_accessor :total_companies
	attr_accessor :public_companies
	attr_accessor :private_companies

	attr_accessor :now_revenue_category
	attr_accessor :now_asset_category
	attr_accessor :now_sales_growth
	attr_accessor :now_gross_profit_margin
	attr_accessor :now_operating_profit_margin
	attr_accessor :now_ebitda_percent
	attr_accessor :now_enterprise_multiple
	attr_accessor :now_ebitda_multiple
	attr_accessor :now_sales_multiple
	attr_accessor :now_debt_multiple
	attr_accessor :cy_revenue_category
	attr_accessor :cy_asset_category
	attr_accessor :cy_sales_growth
	attr_accessor :cy_gross_profit_margin
	attr_accessor :cy_operating_profit_margin
	attr_accessor :cy_ebitda_percent
	attr_accessor :cy_enterprise_multiple
	attr_accessor :cy_ebitda_multiple
	attr_accessor :cy_sales_multiple
	attr_accessor :cy_debt_multiple
	attr_accessor :y2_revenue_category
	attr_accessor :y2_asset_category
	attr_accessor :y2_sales_growth
	attr_accessor :y2_gross_profit_margin
	attr_accessor :y2_operating_profit_margin
	attr_accessor :y2_ebitda_percent
	attr_accessor :y2_enterprise_multiple
	attr_accessor :y2_ebitda_multiple
	attr_accessor :y2_sales_multiple
	attr_accessor :y2_debt_multiple
	attr_accessor :y3_revenue_category
	attr_accessor :y3_asset_category
	attr_accessor :y3_sales_growth
	attr_accessor :y3_gross_profit_margin
	attr_accessor :y3_operating_profit_margin
	attr_accessor :y3_ebitda_percent
	attr_accessor :y3_enterprise_multiple
	attr_accessor :y3_ebitda_multiple
	attr_accessor :y3_sales_multiple
	attr_accessor :y3_debt_multiple

	def initialize (filter_id)
		filter = StatFilter.find(filter_id)

		#gather data for the filter
    #gather all trade stats with revenue category
    tradestats = TradeStat.where(
      filter.revenue_low.to_f==0 ? "" : "revenue_category = #{filter.revenue_low}")
    
    company_ids1 = Array.new
    tradestats.each do |tradestat|
      company_ids1.push(tradestat.company_id)
    end

    users = User.where(
      filter.user_type==nil ? "" : "subtype = #{filter.user_type}")

    user_ids1 = Array.new
    users.each do |user|
      user_ids1.push(user.id)
    end

    #todo: Also filter out non-network valid companies

    #gather the companies that the filter applies to
    companies = Company.where(
      filter.region==0 ? "" : "region = #{filter.region}").where(
      #filter.country==0 ? "" : "country = #{filter.country}").where(
      filter.ownership==0 ? "" : "ownership = #{filter.ownership}").where(
      filter.combination==0 ? "" : "combination = #{filter.combination}").where(
      filter.sic_low.to_f==0 ? "" : "sic = '#{filter.sic_low.to_s}'")     #todo: make sic a string

    companies = companies.where(:id => company_ids1)
    companies_stattrader = companies.where(:user_id => -1)
    companies = companies.where(:user_id => user_ids1)
    companies+=companies_stattrader

    @total_companies = companies.size.to_f

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

    now_revenue_category_sample_size=0
    now_asset_category_sample_size=0
    now_sales_growth_sample_size=0
    now_gross_profit_margin_sample_size=0
    now_operating_profit_margin_sample_size=0
    now_ebitda_percent_sample_size=0
    now_enterprise_multiple_sample_size=0
    now_ebitda_multiple_sample_size=0
    now_sales_multiple_sample_size=0
    now_debt_multiple_sample_size=0
    cy_revenue_category_sample_size=0
    cy_asset_category_sample_size=0
    cy_sales_growth_sample_size=0
    cy_gross_profit_margin_sample_size=0
    cy_operating_profit_margin_sample_size=0
    cy_ebitda_percent_sample_size=0
    cy_enterprise_multiple_sample_size=0
    cy_ebitda_multiple_sample_size=0
    cy_sales_multiple_sample_size=0
    cy_debt_multiple_sample_size=0
    y2_revenue_category_sample_size=0
    y2_asset_category_sample_size=0
    y2_sales_growth_sample_size=0
    y2_gross_profit_margin_sample_size=0
    y2_operating_profit_margin_sample_size=0
    y2_ebitda_percent_sample_size=0
    y2_enterprise_multiple_sample_size=0
    y2_ebitda_multiple_sample_size=0
    y2_sales_multiple_sample_size=0
    y2_debt_multiple_sample_size=0
    y3_revenue_category_sample_size=0
    y3_asset_category_sample_size=0
    y3_sales_growth_sample_size=0
    y3_gross_profit_margin_sample_size=0
    y3_operating_profit_margin_sample_size=0
    y3_ebitda_percent_sample_size=0
    y3_enterprise_multiple_sample_size=0
    y3_ebitda_multiple_sample_size=0
    y3_sales_multiple_sample_size=0
    y3_debt_multiple_sample_size=0

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

      now_revenue_category_sample_size += TradeStat.valid?(trade_now.revenue_category) ? 1 : 0
			now_asset_category_sample_size += TradeStat.valid?(trade_now.asset_category) ? 1 : 0
			now_sales_growth_sample_size += TradeStat.valid?(trade_now.sales_growth) ? 1 : 0
			now_gross_profit_margin_sample_size += TradeStat.valid?(trade_now.gross_profit_margin) ? 1 : 0
			now_operating_profit_margin_sample_size += TradeStat.valid?(trade_now.operating_profit_margin) ? 1 : 0
			now_ebitda_percent_sample_size += TradeStat.valid?(trade_now.ebitda_percent) ? 1 : 0
			now_enterprise_multiple_sample_size += TradeStat.valid?(trade_now.enterprise_multiple) ? 1 : 0
			now_ebitda_multiple_sample_size += TradeStat.valid?(trade_now.ebitda_multiple) ? 1 : 0
			now_sales_multiple_sample_size += TradeStat.valid?(trade_now.sales_multiple) ? 1 : 0
			now_debt_multiple_sample_size += TradeStat.valid?(trade_now.debt_multiple) ? 1 : 0
			cy_revenue_category_sample_size += TradeStat.valid?(trade_cy.revenue_category) ? 1 : 0
			cy_asset_category_sample_size += TradeStat.valid?(trade_cy.asset_category) ? 1 : 0
			cy_sales_growth_sample_size += TradeStat.valid?(trade_cy.sales_growth) ? 1 : 0
			cy_gross_profit_margin_sample_size += TradeStat.valid?(trade_cy.gross_profit_margin) ? 1 : 0
			cy_operating_profit_margin_sample_size += TradeStat.valid?(trade_cy.operating_profit_margin) ? 1 : 0
			cy_ebitda_percent_sample_size += TradeStat.valid?(trade_cy.ebitda_percent) ? 1 : 0
			cy_enterprise_multiple_sample_size += TradeStat.valid?(trade_cy.enterprise_multiple) ? 1 : 0
			cy_ebitda_multiple_sample_size += TradeStat.valid?(trade_cy.ebitda_multiple) ? 1 : 0
			cy_sales_multiple_sample_size += TradeStat.valid?(trade_cy.sales_multiple) ? 1 : 0
			cy_debt_multiple_sample_size += TradeStat.valid?(trade_cy.debt_multiple) ? 1 : 0
			y2_revenue_category_sample_size += TradeStat.valid?(trade_2y.revenue_category) ? 1 : 0
			y2_asset_category_sample_size += TradeStat.valid?(trade_2y.asset_category) ? 1 : 0
			y2_sales_growth_sample_size += TradeStat.valid?(trade_2y.sales_growth) ? 1 : 0
			y2_gross_profit_margin_sample_size += TradeStat.valid?(trade_2y.gross_profit_margin) ? 1 : 0
			y2_operating_profit_margin_sample_size += TradeStat.valid?(trade_2y.operating_profit_margin) ? 1 : 0
			y2_ebitda_percent_sample_size += TradeStat.valid?(trade_2y.ebitda_percent) ? 1 : 0
			y2_enterprise_multiple_sample_size += TradeStat.valid?(trade_2y.enterprise_multiple) ? 1 : 0
			y2_ebitda_multiple_sample_size += TradeStat.valid?(trade_2y.ebitda_multiple) ? 1 : 0
			y2_sales_multiple_sample_size += TradeStat.valid?(trade_2y.sales_multiple) ? 1 : 0
			y2_debt_multiple_sample_size += TradeStat.valid?(trade_2y.debt_multiple) ? 1 : 0
			y3_revenue_category_sample_size += TradeStat.valid?(trade_3y.revenue_category) ? 1 : 0
			y3_asset_category_sample_size += TradeStat.valid?(trade_3y.asset_category) ? 1 : 0
			y3_sales_growth_sample_size += TradeStat.valid?(trade_3y.sales_growth) ? 1 : 0
			y3_gross_profit_margin_sample_size += TradeStat.valid?(trade_3y.gross_profit_margin) ? 1 : 0
			y3_operating_profit_margin_sample_size += TradeStat.valid?(trade_3y.operating_profit_margin) ? 1 : 0
			y3_ebitda_percent_sample_size += TradeStat.valid?(trade_3y.ebitda_percent) ? 1 : 0
			y3_enterprise_multiple_sample_size += TradeStat.valid?(trade_3y.enterprise_multiple) ? 1 : 0
			y3_ebitda_multiple_sample_size += TradeStat.valid?(trade_3y.ebitda_multiple) ? 1 : 0
			y3_sales_multiple_sample_size += TradeStat.valid?(trade_3y.sales_multiple) ? 1 : 0
			y3_debt_multiple_sample_size += TradeStat.valid?(trade_3y.debt_multiple) ? 1 : 0

    end

    #divide all the stats by the sample size to get the average
    @now_revenue_category /= now_revenue_category_sample_size.to_f unless now_revenue_category_sample_size == 0
    @now_asset_category /= now_asset_category_sample_size.to_f unless now_asset_category_sample_size == 0
    @now_sales_growth /= now_sales_growth_sample_size.to_f unless now_sales_growth_sample_size == 0
    @now_gross_profit_margin /= now_gross_profit_margin_sample_size.to_f unless now_gross_profit_margin_sample_size == 0
    @now_operating_profit_margin /= now_operating_profit_margin_sample_size.to_f unless now_operating_profit_margin_sample_size == 0
    @now_ebitda_percent /= now_ebitda_percent_sample_size.to_f unless now_ebitda_percent_sample_size == 0
    @now_enterprise_multiple /= now_enterprise_multiple_sample_size.to_f unless now_enterprise_multiple_sample_size == 0
    @now_ebitda_multiple /= now_ebitda_multiple_sample_size.to_f unless now_ebitda_multiple_sample_size == 0
    @now_sales_multiple /= now_sales_multiple_sample_size.to_f unless now_sales_multiple_sample_size == 0
    @now_debt_multiple /= now_debt_multiple_sample_size.to_f unless now_debt_multiple_sample_size == 0
    @cy_revenue_category /= cy_revenue_category_sample_size.to_f unless cy_revenue_category_sample_size == 0
    @cy_asset_category /= cy_asset_category_sample_size.to_f unless cy_asset_category_sample_size == 0
    @cy_sales_growth /= cy_sales_growth_sample_size.to_f unless cy_sales_growth_sample_size == 0
    @cy_gross_profit_margin /= cy_gross_profit_margin_sample_size.to_f unless cy_gross_profit_margin_sample_size == 0
    @cy_operating_profit_margin /= cy_operating_profit_margin_sample_size.to_f unless cy_operating_profit_margin_sample_size == 0
    @cy_ebitda_percent /= cy_ebitda_percent_sample_size.to_f unless cy_ebitda_percent_sample_size == 0
    @cy_enterprise_multiple /= cy_enterprise_multiple_sample_size.to_f unless cy_enterprise_multiple_sample_size == 0
    @cy_ebitda_multiple /= cy_ebitda_multiple_sample_size.to_f unless cy_ebitda_multiple_sample_size == 0
    @cy_sales_multiple /= cy_sales_multiple_sample_size.to_f unless cy_sales_multiple_sample_size == 0
    @cy_debt_multiple /= cy_debt_multiple_sample_size.to_f unless cy_debt_multiple_sample_size == 0
    @y2_revenue_category /= y2_revenue_category_sample_size.to_f unless y2_revenue_category_sample_size == 0
    @y2_asset_category /= y2_asset_category_sample_size.to_f unless y2_asset_category_sample_size == 0
    @y2_sales_growth /= y2_sales_growth_sample_size.to_f unless y2_sales_growth_sample_size == 0
    @y2_gross_profit_margin /= y2_gross_profit_margin_sample_size.to_f unless y2_gross_profit_margin_sample_size == 0
    @y2_operating_profit_margin /= y2_operating_profit_margin_sample_size.to_f unless y2_operating_profit_margin_sample_size == 0
    @y2_ebitda_percent /= y2_ebitda_percent_sample_size.to_f unless y2_ebitda_percent_sample_size == 0
    @y2_enterprise_multiple /= y2_enterprise_multiple_sample_size.to_f unless y2_enterprise_multiple_sample_size == 0
    @y2_ebitda_multiple /= y2_ebitda_multiple_sample_size.to_f unless y2_ebitda_multiple_sample_size == 0
    @y2_sales_multiple /= y2_sales_multiple_sample_size.to_f unless y2_sales_multiple_sample_size == 0
    @y2_debt_multiple /= y2_debt_multiple_sample_size.to_f unless y2_debt_multiple_sample_size == 0
    @y3_revenue_category /= y3_revenue_category_sample_size.to_f unless y3_revenue_category_sample_size == 0
    @y3_asset_category /= y3_asset_category_sample_size.to_f unless y3_asset_category_sample_size == 0
    @y3_sales_growth /= y3_sales_growth_sample_size.to_f unless y3_sales_growth_sample_size == 0
    @y3_gross_profit_margin /= y3_gross_profit_margin_sample_size.to_f unless y3_gross_profit_margin_sample_size == 0
    @y3_operating_profit_margin /= y3_operating_profit_margin_sample_size.to_f unless y3_operating_profit_margin_sample_size == 0
    @y3_ebitda_percent /= y3_ebitda_percent_sample_size.to_f unless y3_ebitda_percent_sample_size == 0
    @y3_enterprise_multiple /= y3_enterprise_multiple_sample_size.to_f unless y3_enterprise_multiple_sample_size == 0
    @y3_ebitda_multiple /= y3_ebitda_multiple_sample_size.to_f unless y3_ebitda_multiple_sample_size == 0
    @y3_sales_multiple /= y3_sales_multiple_sample_size.to_f unless y3_sales_multiple_sample_size == 0
    @y3_debt_multiple /= y3_debt_multiple_sample_size.to_f unless y3_debt_multiple_sample_size == 0

    #@now_sales_growth = number_with_precision(@now_sales_growth, :precision => 1)

    
	end

end