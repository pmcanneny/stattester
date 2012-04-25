require 'spreadsheet'
Spreadsheet.client_encoding = 'UTF-8'

class Company < ActiveRecord::Base
  belongs_to :user
  validates_presence_of :name
  validates_presence_of :user_id

  #The greatest numbers of months that CY's financial year end can be in the past
  def self.max_cy_range
  	18
  end

  #after creation of a company, initialize all the yearly data columns
  #we must set their company_id as well as set this company's data ids
  #also, set the data column's year type and reporting scale default to 1
  after_create do
  	#the six SecureStat years
  	secure_now = SecureStat.new
  	secure_cy = SecureStat.new
  	secure_2y = SecureStat.new
  	secure_3y = SecureStat.new
  	secure_4y = SecureStat.new
  	secure_5y = SecureStat.new
	secure_now.company_id = self.id
	secure_now.reporting_scale = 1	
	secure_cy.company_id = self.id
	secure_cy.reporting_scale = 1	
	secure_2y.company_id = self.id
	secure_2y.reporting_scale = 1
	secure_3y.company_id = self.id
	secure_3y.reporting_scale = 1
	secure_4y.company_id = self.id
	secure_4y.reporting_scale = 1
	secure_5y.company_id = self.id
	secure_5y.reporting_scale = 1

	secure_now.save
	secure_2y.save
	secure_3y.save
	secure_4y.save
	secure_5y.save

	#saving the cy last to prevent issues
	secure_cy.save

	self.secure_now_id = secure_now.id
	self.secure_cy_id = secure_cy.id
	self.secure_2y_id = secure_2y.id
	self.secure_3y_id = secure_3y.id
	self.secure_4y_id = secure_4y.id
	self.secure_5y_id = secure_5y.id

	#the six TradeStat years
	trade_now = TradeStat.new
  	trade_cy = TradeStat.new
  	trade_2y = TradeStat.new
  	trade_3y = TradeStat.new
  	trade_4y = TradeStat.new
  	trade_5y = TradeStat.new
	trade_now.company_id = self.id
	trade_now.save
	trade_cy.company_id = self.id
	trade_cy.save
	trade_2y.company_id = self.id
	trade_2y.save
	trade_3y.company_id = self.id
	trade_3y.save
	trade_4y.company_id = self.id
	trade_4y.save
	trade_5y.company_id = self.id
	trade_5y.save
	self.trade_now_id = trade_now.id
	self.trade_cy_id = trade_cy.id
	self.trade_2y_id = trade_2y.id
	self.trade_3y_id = trade_3y.id
	self.trade_4y_id = trade_4y.id
	self.trade_5y_id = trade_5y.id

	#initialize the default filter
	filter = StatFilter.new
	filter.name = "default"
	filter.country = 0
	filter.region = 0
	filter.revenue_low = 0
	filter.revenue_high = 0
	filter.asset_low = 0
	filter.asset_high = 0
	filter.sic_low = 0
	filter.sic_high = 0
	filter.combination = 0
	filter.ownership = 0
	filter.input_basis = 0
	filter.save
	self.current_filter_id = filter.id

	self.save  	
  end

  # singleton patterns for the current filter, and stats
  def current_filter
  	unless self.current_filter_id == nil
  		return self.current_filter_id
  	else
  		filter = StatFilter.new
			filter.name = "default"
			filter.country = 0
			filter.region = 0
			filter.revenue_low = 0
			filter.revenue_high = 0
			filter.asset_low = 0
			filter.asset_high = 0
			filter.sic_low = 0
			filter.sic_high = 0
			filter.combination = 0
			filter.ownership = 0
			filter.input_basis = 0
			filter.save
			self.current_filter_id = filter.id
			self.save
			return self.current_filter_id
		end
	end

  #exporting to excel for the data sheet
	def datasheet_xls
		Spreadsheet.client_encoding = 'UTF-8'

	  book = Spreadsheet::Workbook.new
	  sheet1 = book.create_worksheet :name => "#{name} Data"

	  sheet1[0,1] = "Company Profile"
	 	sheet1[1,1] = "Name:"
	 	sheet1[2,1] = "Entity:"
	 	sheet1[3,1] = "Ownership:"
	 	sheet1[4,1] = "SIC code:"
	 	sheet1[5,1] = "Country:"
	 	sheet1[6,1] = "Region:"

	 	sheet1[1,2] = name
	 	sheet1[2,2] = Company.combination(combination)
	 	sheet1[3,2] = Company.ownership(ownership)
	 	sheet1[4,2] = "#{sic} #{Company.four_digit_sics(sic)}"
	 	sheet1[5,2] = Company.country(country)
	 	sheet1[6,2] = Company.region(region)

	 	sheet1[8,0]  = "Company Data"
	 	sheet1[9,0]  = ""
	 	sheet1[10,0] = "Fiscal Year End:"
	 	sheet1[11,0] = "Historical Data Quality:"
	 	sheet1[12,0] = "Reporting Scale:"
	 	sheet1[13,0] = "--Accounts--"
	 	sheet1[14,0] = "Assets:"
	 	sheet1[15,0] = "Revenue:"
	 	sheet1[16,0] = "Gross Profit:"
	 	sheet1[17,0] = "Operating Profit:"
	 	sheet1[18,0] = "EBITDA:"
	 	sheet1[19,0] = "--Valuation--"
	 	sheet1[20,0] = "EBITDA Multiple:"
	 	sheet1[21,0] = "Sales Multiple:"
	 	sheet1[22,0] = "Funded Debt Multiple:"
	 	sheet1[23,0] = "Stock Price:"

		secure_now= SecureStat.find(secure_now_id)
		secure_cy = SecureStat.find(secure_cy_id)
  	secure_2y = SecureStat.find(secure_2y_id)
  	secure_3y = SecureStat.find(secure_3y_id)
  	secure_4y = SecureStat.find(secure_4y_id)
  	secure_5y = SecureStat.find(secure_5y_id)

	 	sheet1[9,1]  = "NOW"
	 	sheet1[10,1] = secure_now.fye == nil ? "" : "#{secure_now.fye.month}/#{secure_now.fye.year}"
	 	sheet1[11,1] = "My Estimate"
	 	sheet1[12,1] = SecureStat.reporting_scale(secure_now.reporting_scale)
	 	sheet1[13,1] = ""
	 	sheet1[14,1] = "#{secure_now.assets}"
	 	sheet1[15,1] = "#{secure_now.gross_sales}"
	 	sheet1[16,1] = "#{secure_now.gross_profit}"
	 	sheet1[17,1] = "#{secure_now.operating_profit}"
	 	sheet1[18,1] = "#{secure_now.ebitda}"
	 	sheet1[19,1] = ""
	 	sheet1[20,1] = "#{secure_now.ebitda_multiple}"
	 	sheet1[21,1] = "#{secure_now.sales_multiple}"
	 	sheet1[22,1] = "#{secure_now.debt_multiple}"
	 	sheet1[23,1] = "#{secure_now.stock_price}"

	 	sheet1[9,2]  = "CY"
	 	sheet1[10,2] = secure_cy.fye == nil ? "" : "#{secure_cy.fye.month}/#{secure_cy.fye.year}"
	 	sheet1[11,2] = SecureStat.quality(secure_cy.quality)
	 	sheet1[12,2] = SecureStat.reporting_scale(secure_cy.reporting_scale)
	 	sheet1[13,2] = ""
	 	sheet1[14,2] = "#{secure_cy.assets}"
	 	sheet1[15,2] = "#{secure_cy.gross_sales}"
	 	sheet1[16,2] = "#{secure_cy.gross_profit}"
	 	sheet1[17,2] = "#{secure_cy.operating_profit}"
	 	sheet1[18,2] = "#{secure_cy.ebitda}"
	 	sheet1[19,2] = ""
	 	sheet1[20,2] = "#{secure_cy.ebitda_multiple}"
	 	sheet1[21,2] = "#{secure_cy.sales_multiple}"
	 	sheet1[22,2] = "#{secure_cy.debt_multiple}"
	 	sheet1[23,2] = "#{secure_cy.stock_price}"

	 	sheet1[9,3]  = "2Y"
	 	sheet1[10,3] = secure_2y.fye == nil ? "" : "#{secure_2y.fye.month}/#{secure_2y.fye.year}"
	 	sheet1[11,3] = SecureStat.quality(secure_2y.quality)
	 	sheet1[12,3] = SecureStat.reporting_scale(secure_2y.reporting_scale)
	 	sheet1[13,3] = ""
	 	sheet1[14,3] = "#{secure_2y.assets}"
	 	sheet1[15,3] = "#{secure_2y.gross_sales}"
	 	sheet1[16,3] = "#{secure_2y.gross_profit}"
	 	sheet1[17,3] = "#{secure_2y.operating_profit}"
	 	sheet1[18,3] = "#{secure_2y.ebitda}"
	 	sheet1[19,3] = ""
	 	sheet1[20,3] = "#{secure_2y.ebitda_multiple}"
	 	sheet1[21,3] = "#{secure_2y.sales_multiple}"
	 	sheet1[22,3] = "#{secure_2y.debt_multiple}"
	 	sheet1[23,3] = "#{secure_2y.stock_price}"

	 	sheet1[9,4]  = "3Y"
	 	sheet1[10,4] = secure_3y.fye == nil ? "" : "#{secure_3y.fye.month}/#{secure_3y.fye.year}"
	 	sheet1[11,4] = SecureStat.quality(secure_3y.quality)
	 	sheet1[12,4] = SecureStat.reporting_scale(secure_3y.reporting_scale)
	 	sheet1[13,4] = ""
	 	sheet1[14,4] = "#{secure_3y.assets}"
	 	sheet1[15,4] = "#{secure_3y.gross_sales}"
	 	sheet1[16,4] = "#{secure_3y.gross_profit}"
	 	sheet1[17,4] = "#{secure_3y.operating_profit}"
	 	sheet1[18,4] = "#{secure_3y.ebitda}"
	 	sheet1[19,4] = ""
	 	sheet1[20,4] = "#{secure_3y.ebitda_multiple}"
	 	sheet1[21,4] = "#{secure_3y.sales_multiple}"
	 	sheet1[22,4] = "#{secure_3y.debt_multiple}"
	 	sheet1[23,4] = "#{secure_3y.stock_price}"

	 	sheet1[9,5]  = "4Y"
	 	sheet1[10,5] = secure_4y.fye == nil ? "" : "#{secure_4y.fye.month}/#{secure_4y.fye.year}"
	 	sheet1[11,5] = SecureStat.quality(secure_4y.quality)
	 	sheet1[12,5] = SecureStat.reporting_scale(secure_4y.reporting_scale)
	 	sheet1[13,5] = ""
	 	sheet1[14,5] = "#{secure_4y.assets}"
	 	sheet1[15,5] = "#{secure_4y.gross_sales}"
	 	sheet1[16,5] = "#{secure_4y.gross_profit}"
	 	sheet1[17,5] = "#{secure_4y.operating_profit}"
	 	sheet1[18,5] = "#{secure_4y.ebitda}"
	 	sheet1[19,5] = ""
	 	sheet1[20,5] = "#{secure_4y.ebitda_multiple}"
	 	sheet1[21,5] = "#{secure_4y.sales_multiple}"
	 	sheet1[22,5] = "#{secure_4y.debt_multiple}"
	 	sheet1[23,5] = "#{secure_4y.stock_price}"

	 	sheet1[9,6]  = "5Y"
	 	sheet1[10,6] = secure_5y.fye == nil ? "" : "#{secure_5y.fye.month}/#{secure_5y.fye.year}"
	 	sheet1[11,6] = SecureStat.quality(secure_5y.quality)
	 	sheet1[12,6] = SecureStat.reporting_scale(secure_5y.reporting_scale)
	 	sheet1[13,6] = ""
	 	sheet1[14,6] = "#{secure_5y.assets}"
	 	sheet1[15,6] = "#{secure_5y.gross_sales}"
	 	sheet1[16,6] = "#{secure_5y.gross_profit}"
	 	sheet1[17,6] = "#{secure_5y.operating_profit}"
	 	sheet1[18,6] = "#{secure_5y.ebitda}"
	 	sheet1[19,6] = ""
	 	sheet1[20,6] = "#{secure_5y.ebitda_multiple}"
	 	sheet1[21,6] = "#{secure_5y.sales_multiple}"
	 	sheet1[22,6] = "#{secure_5y.debt_multiple}"
	 	sheet1[23,6] = "#{secure_5y.stock_price}"

	 	trade_now= TradeStat.find(trade_now_id)
  	trade_cy = TradeStat.find(trade_cy_id)
  	trade_2y = TradeStat.find(trade_2y_id)
  	trade_3y = TradeStat.find(trade_3y_id)
  	trade_4y = TradeStat.find(trade_4y_id)
  	trade_5y = TradeStat.find(trade_5y_id)

  	sheet1[25,0] = "Company Statistics (Stat Trade)"
	 	sheet1[26,0] = ""
	 	sheet1[27,0] = "--Accounts--"
	 	sheet1[28,0] = "Asset Category:"
	 	sheet1[29,0] = "Revenue Category:"
	 	sheet1[30,0] = "Sales/Revenue Growth:"
	 	sheet1[31,0] = "Gross Profit Margin:"
	 	sheet1[32,0] = "Operating Profit Margin:"
	 	sheet1[33,0] = "EBITDA %:"
	 	sheet1[34,0] = "--Valuation--"
	 	sheet1[35,0] = "EBITDA Multiple:"
	 	sheet1[36,0] = "Sales Multiple:"
	 	sheet1[37,0] = "Funded Debt Multiple:"

	 	sheet1[26,1] = "NOW"
	 	sheet1[27,1] = ""
	 	sheet1[28,1] = "#{trade_now.asset_category}"
	 	sheet1[29,1] = "#{trade_now.revenue_category}"
	 	sheet1[30,1] = "#{trade_now.sales_growth}"
	 	sheet1[31,1] = "#{trade_now.gross_profit_margin}"
	 	sheet1[32,1] = "#{trade_now.operating_profit_margin}"
	 	sheet1[33,1] = "#{trade_now.ebitda_percent}"
	 	sheet1[34,1] = ""
	 	sheet1[35,1] = "#{trade_now.ebitda_multiple}"
	 	sheet1[36,1] = "#{trade_now.sales_multiple}"
	 	sheet1[37,1] = "#{trade_now.debt_multiple}"

	 	sheet1[26,2] = "CY"
	 	sheet1[27,2] = ""
	 	sheet1[28,2] = "#{trade_cy.asset_category}"
	 	sheet1[29,2] = "#{trade_cy.revenue_category}"
	 	sheet1[30,2] = "#{trade_cy.sales_growth}"
	 	sheet1[31,2] = "#{trade_cy.gross_profit_margin}"
	 	sheet1[32,2] = "#{trade_cy.operating_profit_margin}"
	 	sheet1[33,2] = "#{trade_cy.ebitda_percent}"
	 	sheet1[34,2] = ""
	 	sheet1[35,2] = "#{trade_cy.ebitda_multiple}"
	 	sheet1[36,2] = "#{trade_cy.sales_multiple}"
	 	sheet1[37,2] = "#{trade_cy.debt_multiple}"

	 	sheet1[26,3] = "2Y"
	 	sheet1[27,3] = ""
	 	sheet1[28,3] = "#{trade_2y.asset_category}"
	 	sheet1[29,3] = "#{trade_2y.revenue_category}"
	 	sheet1[30,3] = "#{trade_2y.sales_growth}"
	 	sheet1[31,3] = "#{trade_2y.gross_profit_margin}"
	 	sheet1[32,3] = "#{trade_2y.operating_profit_margin}"
	 	sheet1[33,3] = "#{trade_2y.ebitda_percent}"
	 	sheet1[34,3] = ""
	 	sheet1[35,3] = "#{trade_2y.ebitda_multiple}"
	 	sheet1[36,3] = "#{trade_2y.sales_multiple}"
	 	sheet1[37,3] = "#{trade_2y.debt_multiple}"

	 	sheet1[26,4] = "3Y"
	 	sheet1[27,4] = ""
	 	sheet1[28,4] = "#{trade_3y.asset_category}"
	 	sheet1[29,4] = "#{trade_3y.revenue_category}"
	 	sheet1[30,4] = "#{trade_3y.sales_growth}"
	 	sheet1[31,4] = "#{trade_3y.gross_profit_margin}"
	 	sheet1[32,4] = "#{trade_3y.operating_profit_margin}"
	 	sheet1[33,4] = "#{trade_3y.ebitda_percent}"
	 	sheet1[34,4] = ""
	 	sheet1[35,4] = "#{trade_3y.ebitda_multiple}"
	 	sheet1[36,4] = "#{trade_3y.sales_multiple}"
	 	sheet1[37,4] = "#{trade_3y.debt_multiple}"

	 	sheet1[26,5] = "4Y"
	 	sheet1[27,5] = ""
	 	sheet1[28,5] = "#{trade_4y.asset_category}"
	 	sheet1[29,5] = "#{trade_4y.revenue_category}"
	 	sheet1[30,5] = "#{trade_4y.sales_growth}"
	 	sheet1[31,5] = "#{trade_4y.gross_profit_margin}"
	 	sheet1[32,5] = "#{trade_4y.operating_profit_margin}"
	 	sheet1[33,5] = "#{trade_4y.ebitda_percent}"
	 	sheet1[34,5] = ""
	 	sheet1[35,5] = "#{trade_4y.ebitda_multiple}"
	 	sheet1[36,5] = "#{trade_4y.sales_multiple}"
	 	sheet1[37,5] = "#{trade_4y.debt_multiple}"

	 	sheet1[26,6] = "5Y"
	 	sheet1[27,6] = ""
	 	sheet1[28,6] = "#{trade_5y.asset_category}"
	 	sheet1[29,6] = "#{trade_5y.revenue_category}"
	 	sheet1[30,6] = "#{trade_5y.sales_growth}"
	 	sheet1[31,6] = "#{trade_5y.gross_profit_margin}"
	 	sheet1[32,6] = "#{trade_5y.operating_profit_margin}"
	 	sheet1[33,6] = "#{trade_5y.ebitda_percent}"
	 	sheet1[34,6] = ""
	 	sheet1[35,6] = "#{trade_5y.ebitda_multiple}"
	 	sheet1[36,6] = "#{trade_5y.sales_multiple}"
	 	sheet1[37,6] = "#{trade_5y.debt_multiple}"


	  spreadsheet = StringIO.new 
		book.write spreadsheet 
		spreadsheet
	end

	#exporting to excel for the data sheet
	def networkstats_xls(netstats)
		Spreadsheet.client_encoding = 'UTF-8'

	  book = Spreadsheet::Workbook.new
	  sheet1 = book.create_worksheet :name => "#{name} Data"

	  sheet1[0,1] = "Company Profile"
	 	sheet1[1,1] = "Name:"
	 	sheet1[2,1] = "Entity:"
	 	sheet1[3,1] = "Ownership:"
	 	sheet1[4,1] = "SIC code:"
	 	sheet1[5,1] = "Country:"
	 	sheet1[6,1] = "Region:"

	 	sheet1[1,2] = name
	 	sheet1[2,2] = Company.combination(combination)
	 	sheet1[3,2] = Company.ownership(ownership)
	 	sheet1[4,2] = "#{sic} #{Company.four_digit_sics(sic)}"
	 	sheet1[5,2] = Company.country(country)
	 	sheet1[6,2] = Company.region(region)

	 	trade_now= TradeStat.find(trade_now_id)
  	trade_cy = TradeStat.find(trade_cy_id)
  	trade_2y = TradeStat.find(trade_2y_id)
  	trade_3y = TradeStat.find(trade_3y_id)
  	trade_4y = TradeStat.find(trade_4y_id)
  	trade_5y = TradeStat.find(trade_5y_id)

  	sheet1[8,0] = "Company Statistics (Stat Trade)"
	 	sheet1[9,0] = ""
	 	sheet1[10,0] = "--Accounts--"
	 	sheet1[11,0] = "Asset Category:"
	 	sheet1[12,0] = "Revenue Category:"
	 	sheet1[13,0] = "Sales/Revenue Growth:"
	 	sheet1[14,0] = "Gross Profit Margin:"
	 	sheet1[15,0] = "Operating Profit Margin:"
	 	sheet1[16,0] = "EBITDA %:"
	 	sheet1[17,0] = "--Valuation--"
	 	sheet1[18,0] = "EBITDA Multiple:"
	 	sheet1[19,0] = "Sales Multiple:"
	 	sheet1[20,0] = "Funded Debt Multiple:"

	 	sheet1[9,1] = "NOW"
	 	sheet1[10,1] = ""
	 	sheet1[11,1] = "#{trade_now.asset_category}"
	 	sheet1[12,1] = "#{trade_now.revenue_category}"
	 	sheet1[13,1] = "#{trade_now.sales_growth}"
	 	sheet1[14,1] = "#{trade_now.gross_profit_margin}"
	 	sheet1[15,1] = "#{trade_now.operating_profit_margin}"
	 	sheet1[16,1] = "#{trade_now.ebitda_percent}"
	 	sheet1[17,1] = ""
	 	sheet1[18,1] = "#{trade_now.ebitda_multiple}"
	 	sheet1[19,1] = "#{trade_now.sales_multiple}"
	 	sheet1[20,1] = "#{trade_now.debt_multiple}"

	 	sheet1[9,2] = "CY"
	 	sheet1[10,2] = ""
	 	sheet1[11,2] = "#{trade_cy.asset_category}"
	 	sheet1[12,2] = "#{trade_cy.revenue_category}"
	 	sheet1[13,2] = "#{trade_cy.sales_growth}"
	 	sheet1[14,2] = "#{trade_cy.gross_profit_margin}"
	 	sheet1[15,2] = "#{trade_cy.operating_profit_margin}"
	 	sheet1[16,2] = "#{trade_cy.ebitda_percent}"
	 	sheet1[17,2] = ""
	 	sheet1[18,2] = "#{trade_cy.ebitda_multiple}"
	 	sheet1[19,2] = "#{trade_cy.sales_multiple}"
	 	sheet1[20,2] = "#{trade_cy.debt_multiple}"

	 	sheet1[9,3] = "2Y"
	 	sheet1[10,3] = ""
	 	sheet1[11,3] = "#{trade_2y.asset_category}"
	 	sheet1[12,3] = "#{trade_2y.revenue_category}"
	 	sheet1[13,3] = "#{trade_2y.sales_growth}"
	 	sheet1[14,3] = "#{trade_2y.gross_profit_margin}"
	 	sheet1[15,3] = "#{trade_2y.operating_profit_margin}"
	 	sheet1[16,3] = "#{trade_2y.ebitda_percent}"
	 	sheet1[17,3] = ""
	 	sheet1[18,3] = "#{trade_2y.ebitda_multiple}"
	 	sheet1[19,3] = "#{trade_2y.sales_multiple}"
	 	sheet1[20,3] = "#{trade_2y.debt_multiple}"

	 	sheet1[9,4] = "3Y"
	 	sheet1[10,4] = ""
	 	sheet1[11,4] = "#{trade_3y.asset_category}"
	 	sheet1[12,4] = "#{trade_3y.revenue_category}"
	 	sheet1[13,4] = "#{trade_3y.sales_growth}"
	 	sheet1[14,4] = "#{trade_3y.gross_profit_margin}"
	 	sheet1[15,4] = "#{trade_3y.operating_profit_margin}"
	 	sheet1[16,4] = "#{trade_3y.ebitda_percent}"
	 	sheet1[17,4] = ""
	 	sheet1[18,4] = "#{trade_3y.ebitda_multiple}"
	 	sheet1[19,4] = "#{trade_3y.sales_multiple}"
	 	sheet1[20,4] = "#{trade_3y.debt_multiple}"

	 	# sheet1[9,5] = "4Y"
	 	# sheet1[10,5] = ""
	 	# sheet1[11,5] = "#{trade_4y.asset_category}"
	 	# sheet1[12,5] = "#{trade_4y.revenue_category}"
	 	# sheet1[13,5] = "#{trade_4y.sales_growth}"
	 	# sheet1[14,5] = "#{trade_4y.gross_profit_margin}"
	 	# sheet1[15,5] = "#{trade_4y.operating_profit_margin}"
	 	# sheet1[16,5] = "#{trade_4y.ebitda_percent}"
	 	# sheet1[17,5] = ""
	 	# sheet1[18,5] = "#{trade_4y.ebitda_multiple}"
	 	# sheet1[19,5] = "#{trade_4y.sales_multiple}"
	 	# sheet1[20,5] = "#{trade_4y.debt_multiple}"

	 	# sheet1[9,6] = "5Y"
	 	# sheet1[10,6] = ""
	 	# sheet1[11,6] = "#{trade_5y.asset_category}"
	 	# sheet1[12,6] = "#{trade_5y.revenue_category}"
	 	# sheet1[13,6] = "#{trade_5y.sales_growth}"
	 	# sheet1[14,6] = "#{trade_5y.gross_profit_margin}"
	 	# sheet1[15,6] = "#{trade_5y.operating_profit_margin}"
	 	# sheet1[16,6] = "#{trade_5y.ebitda_percent}"
	 	# sheet1[17,6] = ""
	 	# sheet1[18,6] = "#{trade_5y.ebitda_multiple}"
	 	# sheet1[19,6] = "#{trade_5y.sales_multiple}"
	 	# sheet1[20,6] = "#{trade_5y.debt_multiple}"

	 	sheet1[8,6] = "Network Statistics"
	 	sheet1[9,6] = "NOW"
	 	sheet1[10,6] = ""
	 	sheet1[11,6] = "#{netstats.now_asset_category}"
	 	sheet1[12,6] = "#{netstats.now_revenue_category}"
	 	sheet1[13,6] = "#{netstats.now_sales_growth}"
	 	sheet1[14,6] = "#{netstats.now_gross_profit_margin}"
	 	sheet1[15,6] = "#{netstats.now_operating_profit_margin}"
	 	sheet1[16,6] = "#{netstats.now_ebitda_percent}"
	 	sheet1[17,6] = ""
	 	sheet1[18,6] = "#{netstats.now_ebitda_multiple}"
	 	sheet1[19,6] = "#{netstats.now_sales_multiple}"
	 	sheet1[20,6] = "#{netstats.now_debt_multiple}"

	 	sheet1[9,7] = "CY"
	 	sheet1[10,7] = ""
	 	sheet1[11,7] = "#{netstats.cy_asset_category}"
	 	sheet1[12,7] = "#{netstats.cy_revenue_category}"
	 	sheet1[13,7] = "#{netstats.cy_sales_growth}"
	 	sheet1[14,7] = "#{netstats.cy_gross_profit_margin}"
	 	sheet1[15,7] = "#{netstats.cy_operating_profit_margin}"
	 	sheet1[16,7] = "#{netstats.cy_ebitda_percent}"
	 	sheet1[17,7] = ""
	 	sheet1[18,7] = "#{netstats.cy_ebitda_multiple}"
	 	sheet1[19,7] = "#{netstats.cy_sales_multiple}"
	 	sheet1[20,7] = "#{netstats.cy_debt_multiple}"

	 	sheet1[9,8] = "2Y"
	 	sheet1[10,8] = ""
	 	sheet1[11,8] = "#{netstats.y2_asset_category}"
	 	sheet1[12,8] = "#{netstats.y2_revenue_category}"
	 	sheet1[13,8] = "#{netstats.y2_sales_growth}"
	 	sheet1[14,8] = "#{netstats.y2_gross_profit_margin}"
	 	sheet1[15,8] = "#{netstats.y2_operating_profit_margin}"
	 	sheet1[16,8] = "#{netstats.y2_ebitda_percent}"
	 	sheet1[17,8] = ""
	 	sheet1[18,8] = "#{netstats.y2_ebitda_multiple}"
	 	sheet1[19,8] = "#{netstats.y2_sales_multiple}"
	 	sheet1[20,8] = "#{netstats.y2_debt_multiple}"

	 	sheet1[9,9] = "3Y"
	 	sheet1[10,9] = ""
	 	sheet1[11,9] = "#{netstats.y3_asset_category}"
	 	sheet1[12,9] = "#{netstats.y3_revenue_category}"
	 	sheet1[13,9] = "#{netstats.y3_sales_growth}"
	 	sheet1[14,9] = "#{netstats.y3_gross_profit_margin}"
	 	sheet1[15,9] = "#{netstats.y3_operating_profit_margin}"
	 	sheet1[16,9] = "#{netstats.y3_ebitda_percent}"
	 	sheet1[17,9] = ""
	 	sheet1[18,9] = "#{netstats.y3_ebitda_multiple}"
	 	sheet1[19,9] = "#{netstats.y3_sales_multiple}"
	 	sheet1[20,9] = "#{netstats.y3_debt_multiple}"


	  spreadsheet = StringIO.new 
		book.write spreadsheet 
		spreadsheet
	end

  #the method through which the year shift update is checked and applied
  #all companies are checked and if needed, the shift happens and the shifted companies are flagged
  def self.monthly_update
  	companies = Company.all
  	for company in companies
  	  cy = SecureStat.find(company.secure_cy)
  	  if ((DateTime.now.year-cy.fye.year)*12 + (DateTime.now.month-cy.fye.month)) > Company.max_cy_range
  	  	company.shift_years
  	  end
  	end
  end

  #perform the year shift on the data pieces
  #TODO:complete
  def shift_years
  	secure_cy = SecureStat.find(self.secure_cy_id)
  	secure_2y = SecureStat.find(self.secure_2y_id)
  	secure_3y = SecureStat.find(self.secure_3y_id)
  	secure_4y = SecureStat.find(self.secure_4y_id)
  	secure_5y = SecureStat.find(self.secure_5y_id)
  	trade_cy = TradeStat.find(self.trade_cy_id)
  	trade_2y = TradeStat.find(self.trade_2y_id)
  	trade_3y = TradeStat.find(self.trade_3y_id)
  	trade_4y = TradeStat.find(self.trade_4y_id)
  	trade_5y = TradeStat.find(self.trade_5y_id)
  	
  	#secure_cy.year = 
  end
  
  #define the options for Reporting Entity
  def self.combination(r)
	case r
	when 1
		"Combination"
	when 2
		"Not a Combination"
	end
  end
  #combination options in hash form - for use in drop-down menus
  def self.combination_options
  	{Company.combination(1)=>1,Company.combination(2)=>2}
  end

  #define the options for Ownership
  def self.ownership(o)
	case o
	when 1
		"Public"
	when 2
		"Private Investor"
	when 3
		"Private Operator"
	end
  end
  #ownership options in hash form - for use in drop-down menus
  def self.ownership_options
  	{Company.ownership(1)=>1,Company.ownership(2)=>2,Company.ownership(3)=>3}
  end

  #define the options for Region
  def self.region(r)
	case r
	when 1
		"Northeast"
	when 2
		"Upper Midwest"
	when 3
		"Northwest"
	when 4
		"Southeast"
	when 5
		"Lower Midwest"
	when 6
		"Southwest"
	when 7
		"West"
	end
  end
  #region options in hash form - for use in drop-down menus
  def self.region_options
  	{Company.region(1)=>1,Company.region(2)=>2,Company.region(3)=>3,Company.region(4)=>4,Company.region(5)=>5,Company.region(6)=>6,Company.region(7)=>7}
  end

  #define the options for Country
  def self.country(c)
	case c
	when 1
		"United States"
	end
  end
  #Country options in hash form - for use in drop-down menus
  def self.country_options
  	{Company.country(1)=>1}
  end

  #four-digit sic codes below
  def self.four_digit_sics(s)
  	case s
  		when "0111"
  		 "WHEAT"
			when "0112"
			 "RICE"
			when "0115"
			 "CORN"
			when "0116"
			 "SOYBEANS"
			when "0119"
			 "CASH GRAINS, NOT ELSEWHERE CLASSIFIED"
			when "0131"
			 "COTTON"
			when "0132"
			 "TOBACCO"
			when "0133"
			 "SUGARCANE AND SUGAR BEETS"
			when "0134"
			 "IRISH POTATOES"
			when "0139"
			 "FIELD CROPS, EXCEPT CASH GRAINS, NOT ELSEWHERE CLASSIFIED"
			when "0161"
			 "VEGETABLES AND MELONS"
			when "0171"
			 "BERRY CROPS"
			when "0172"
			 "GRAPES"
			when "0173"
			 "TREE NUTS"
			when "0174"
			 "CITRUS FRUITS"
			when "0175"
			 "DECIDUOUS TREE FRUITS"
			when "0179"
			 "FRUITS AND TREE NUTS, NOT ELSEWHERE CLASSIFIED"
			when "0181"
			 "ORNAMENTAL FLORICULTURE AND NURSERY PRODUCTS"
			when "0182"
			 "FOOD CROPS GROWN UNDER COVER"
			when "0191"
			 "GENERAL FARMS, PRIMARILY CROP"
			when "0211"
			 "BEEF CATTLE FEEDLOTS"
			when "0212"
			 "BEEF CATTLE, EXCEPT FEEDLOTS"
			when "0213"
			 "HOGS"
			when "0214"
			 "SHEEP AND GOATS"
			when "0219"
			 "GENERAL LIVESTOCK, EXCEPT DAIRY AND POULTRY"
			when "0241"
			 "DAIRY FARMS"
			when "0251"
			 "BROILER, FRYER, AND ROASTER CHICKENS"
			when "0252"
			 "CHICKEN EGGS"
			when "0253"
			 "TURKEYS AND TURKEY EGGS"
			when "0254"
			 "POULTRY HATCHERIES"
			when "0259"
			 "POULTRY AND EGGS, NOT ELSEWHERE CLASSIFIED"
			when "0271"
			 "FUR-BEARING ANIMALS AND RABBITS"
			when "0272"
			 "HORSES AND OTHER EQUINES"
			when "0273"
			 "ANIMAL AQUACULTURE"
			when "0279"
			 "ANIMAL SPECIALTIES, NOT ELSEWHERE CLASSIFIED"
			when "0291"
			 "GENERAL FARMS, PRIMARILY LIVESTOCK AND ANIMAL SPECIALTIES"
			when "0711"
			 "SOIL PREPARATION SERVICES"
			when "0721"
			 "CROP PLANTING, CULTIVATING, AND PROTECTING"
			when "0722"
			 "CROP HARVESTING, PRIMARILY BY MACHINE"
			when "0723"
			 "CROP PREPARATION SERVICES FOR MARKET, EXCEPT COTTON GINNING"
			when "0724"
			 "COTTON GINNING"
			when "0741"
			 "VETERINARY SERVICES FOR LIVESTOCK"
			when "0742"
			 "VETERINARY SERVICES FOR ANIMAL SPECIALTIES"
			when "0751"
			 "LIVESTOCK SERVICES, EXCEPT VETERINARY"
			when "0752"
			 "ANIMAL SPECIALTY SERVICES, EXCEPT VETERINARY"
			when "0761"
			 "FARM LABOR CONTRACTORS AND CREW LEADERS"
			when "0762"
			 "FARM MANAGEMENT SERVICES"
			when "0781"
			 "LANDSCAPE COUNSELING AND PLANNING"
			when "0782"
			 "LAWN AND GARDEN SERVICES"
			when "0783"
			 "ORNAMENTAL SHRUB AND TREE SERVICES"
			when "0811"
			 "TIMBER TRACTS"
			when "0831"
			 "FOREST NURSERIES AND GATHERING OF FOREST PRODUCTS"
			when "0851"
			 "FORESTRY SERVICES"
			when "0912"
			 "FINFISH"
			when "0913"
			 "SHELLFISH"
			when "0919"
			 "MISCELLANEOUS MARINE PRODUCTS"
			when "0921"
			 "FISH HATCHERIES AND PRESERVES"
			when "0971"
			 "HUNTING AND TRAPPING, AND GAME PROPAGATION"
			when "1011"
			 "IRON ORES"
			when "1021"
			 "COPPER ORES"
			when "1031"
			 "LEAD AND ZINC ORES"
			when "1041"
			 "GOLD ORES"
			when "1044"
			 "SILVER ORES"
			when "1061"
			 "FERROALLOY ORES, EXCEPT VANADIUM"
			when "1081"
			 "METAL MINING SERVICES"
			when "1094"
			 "URANIUM-RADIUM-VANADIUM ORES"
			when "1099"
			 "MISCELLANEOUS METAL ORES, NOT ELSEWHERE CLASSIFIED"
			when "1221"
			 "BITUMINOUS COAL AND LIGNITE SURFACE MINING"
			when "1222"
			 "BITUMINOUS COAL UNDERGROUND MINING"
			when "1231"
			 "ANTHRACITE MINING"
			when "1241"
			 "COAL MINING SERVICES"
			when "1311"
			 "CRUDE PETROLEUM AND NATURAL GAS"
			when "1321"
			 "NATURAL GAS LIQUIDS"
			when "1381"
			 "DRILLING OIL AND GAS WELLS"
			when "1382"
			 "OIL AND GAS FIELD EXPLORATION SERVICES"
			when "1389"
			 "OIL AND GAS FIELD SERVICES, NOT ELSEWHERE CLASSIFIED"
			when "1411"
			 "DIMENSION STONE"
			when "1422"
			 "CRUSHED AND BROKEN LIMESTONE"
			when "1423"
			 "CRUSHED AND BROKEN GRANITE"
			when "1429"
			 "CRUSHED AND BROKEN STONE, NOT ELSEWHERE CLASSIFIED"
			when "1442"
			 "CONSTRUCTION SAND AND GRAVEL"
			when "1446"
			 "INDUSTRIAL SAND"
			when "1455"
			 "KAOLIN AND BALL CLAY"
			when "1459"
			 "CLAY, CERAMIC, AND REFRACTORY MINERALS, NOT ELSEWHERE CLASSIFIED"
			when "1474"
			 "POTASH, SODA, AND BORATE MINERALS"
			when "1475"
			 "PHOSPHATE ROCK"
			when "1479"
			 "CHEMICAL AND FERTILIZER MINERAL MINING, NOT ELSEWHERE CLASSIFIED"
			when "1481"
			 "NONMETALLIC MINERALS SERVICES, EXCEPT FUELS"
			when "1499"
			 "MISCELLANEOUS NONMETALLIC MINERALS, EXCEPT FUELS"
			when "1521"
			 "GENERAL CONTRACTORS-SINGLE-FAMILY HOUSES"
			when "1522"
			 "GENERAL CONTRACTORS-RESIDENTIAL BUILDINGS, OTHER THAN SINGLE-FAMI"
			when "1531"
			 "OPERATIVE BUILDERS"
			when "1541"
			 "GENERAL CONTRACTORS-INDUSTRIAL BUILDINGS AND WAREHOUSES"
			when "1542"
			 "GENERAL CONTRACTORS-NONRESIDENTIAL BUILDINGS, OTHER THAN INDUSTRI"
			when "1611"
			 "HIGHWAY AND STREET CONSTRUCTION, EXCEPT ELEVATED HIGHWAYS"
			when "1622"
			 "BRIDGE, TUNNEL, AND ELEVATED HIGHWAY CONSTRUCTION"
			when "1623"
			 "WATER, SEWER, PIPELINE, AND COMMUNICATIONS AND POWER LINE CONSTRU"
			when "1629"
			 "HEAVY CONSTRUCTION, NOT ELSEWHERE CLASSIFIED"
			when "1711"
			 "PLUMBING, HEATING AND AIR-CONDITIONING"
			when "1721"
			 "PAINTING AND PAPER HANGING"
			when "1731"
			 "ELECTRICAL WORK"
			when "1741"
			 "MASONRY, STONE SETTING, AND OTHER STONE WORK"
			when "1742"
			 "PLASTERING, DRYWALL, ACOUSTICAL, AND INSULATION WORK"
			when "1743"
			 "TERRAZZO, TILE, MARBLE, AND MOSAIC WORK"
			when "1751"
			 "CARPENTRY WORK"
			when "1752"
			 "FLOOR LAYING AND OTHER FLOOR WORK, NOT ELSEWHERE CLASSIFIED"
			when "1761"
			 "ROOFING, SIDING, AND SHEET METAL WORK"
			when "1771"
			 "CONCRETE WORK"
			when "1781"
			 "WATER WELL DRILLING"
			when "1791"
			 "STRUCTURAL STEEL ERECTION"
			when "1793"
			 "GLASS AND GLAZING WORK"
			when "1794"
			 "EXCAVATION WORK"
			when "1795"
			 "WRECKING AND DEMOLITION WORK"
			when "1796"
			 "INSTALLATION OR ERECTION OF BUILDING EQUIPMENT, NOT ELSEWHERE CLA"
			when "1799"
			 "SPECIAL TRADE CONTRACTORS, NOT ELSEWHERE CLASSIFIED"
			when "2011"
			 "MEAT PACKING PLANTS"
			when "2013"
			 "SAUSAGES AND OTHER PREPARED MEAT PRODUCTS"
			when "2015"
			 "POULTRY SLAUGHTERING AND PROCESSING"
			when "2021"
			 "CREAMERY BUTTER"
			when "2022"
			 "NATURAL, PROCESSED, AND IMITATION CHEESE"
			when "2023"
			 "DRY, CONDENSED, AND EVAPORATED DAIRY PRODUCTS"
			when "2024"
			 "ICE CREAM AND FROZEN DESSERTS"
			when "2026"
			 "FLUID MILK"
			when "2032"
			 "CANNED SPECIALTIES"
			when "2033"
			 "CANNED FRUITS, VEGETABLES, PRESERVES, JAMS, AND JELLIES"
			when "2034"
			 "DRIED AND DEHYDRATED FRUITS, VEGETABLES, AND SOUP MIXES"
			when "2035"
			 "PICKLED FRUITS AND VEGETABLES, VEGETABLE SAUCES AND SEASONINGS, A"
			when "2037"
			 "FROZEN FRUITS, FRUIT JUICES, AND VEGETABLES"
			when "2038"
			 "FROZEN SPECIALTIES, NOT ELSEWHERE CLASSIFIED"
			when "2041"
			 "FLOUR AND OTHER GRAIN MILL PRODUCTS"
			when "2043"
			 "CEREAL BREAKFAST FOODS"
			when "2044"
			 "RICE MILLING"
			when "2045"
			 "PREPARED FLOUR MIXES AND DOUGHS"
			when "2046"
			 "WET CORN MILLING"
			when "2047"
			 "DOG AND CAT FOOD"
			when "2048"
			 "PREPARED FEEDS AND FEED INGREDIENTS FOR ANIMALS AND FOWLS, EXCEPT"
			when "2051"
			 "BREAD AND OTHER BAKERY PRODUCTS, EXCEPT COOKIES AND CRACKERS"
			when "2052"
			 "COOKIES AND CRACKERS"
			when "2053"
			 "FROZEN BAKERY PRODUCTS, EXCEPT BREAD"
			when "2061"
			 "CANE SUGAR, EXCEPT REFINING"
			when "2062"
			 "CANE SUGAR REFINING"
			when "2063"
			 "BEET SUGAR"
			when "2064"
			 "CANDY AND OTHER CONFECTIONERY PRODUCTS"
			when "2066"
			 "CHOCOLATE AND COCOA PRODUCTS"
			when "2067"
			 "CHEWING GUM"
			when "2068"
			 "SALTED AND ROASTED NUTS AND SEEDS"
			when "2074"
			 "COTTONSEED OIL MILLS"
			when "2075"
			 "SOYBEAN OIL MILLS"
			when "2076"
			 "VEGETABLE OIL MILLS, EXCEPT CORN, COTTONSEED, AND SOYBEAN"
			when "2077"
			 "ANIMAL AND MARINE FATS AND OILS"
			when "2079"
			 "SHORTENING, TABLE OILS, MARGARINE, AND OTHER EDIBLE FATS AND OILS"
			when "2082"
			 "MALT BEVERAGES"
			when "2083"
			 "MALT"
			when "2084"
			 "WINES, BRANDY, AND BRANDY SPIRITS"
			when "2085"
			 "DISTILLED AND BLENDED LIQUORS"
			when "2086"
			 "BOTTLED AND CANNED SOFT DRINKS AND CARBONATED WATERS"
			when "2087"
			 "FLAVORING EXTRACTS AND FLAVORING SYRUPS, NOT ELSEWHERE CLASSIFIED"
			when "2091"
			 "CANNED AND CURED FISH AND SEAFOODS"
			when "2092"
			 "PREPARED FRESH OR FROZEN FISH AND SEAFOODS"
			when "2095"
			 "ROASTED COFFEE"
			when "2096"
			 "POTATO CHIPS, CORN CHIPS, AND SIMILAR SNACKS"
			when "2097"
			 "MANUFACTURED ICE"
			when "2098"
			 "MACARONI, SPAGHETTI, VERMICELLI, AND NOODLES"
			when "2099"
			 "FOOD PREPARATIONS, NOT ELSEWHERE CLASSIFIED"
			when "2111"
			 "CIGARETTES"
			when "2121"
			 "CIGARS"
			when "2131"
			 "CHEWING AND SMOKING TOBACCO AND SNUFF"
			when "2141"
			 "TOBACCO STEMMING AND REDRYING"
			when "2211"
			 "BROADWOVEN FABRIC MILLS, COTTON"
			when "2221"
			 "BROADWOVEN FABRIC MILLS, MANMADE FIBER AND SILK"
			when "2231"
			 "BROADWOVEN FABRIC MILLS, WOOL (INCLUDING DYEING AND FINISHING)"
			when "2241"
			 "NARROW FABRIC AND OTHER SMALLWARES MILLS: COTTON, WOOL, SILK, AND"
			when "2251"
			 "WOMEN'S FULL-LENGTH AND KNEE-LENGTH HOSIERY, EXCEPT SOCKS"
			when "2252"
			 "HOSIERY, NOT ELSEWHERE CLASSIFIED"
			when "2253"
			 "KNIT OUTERWEAR MILLS"
			when "2254"
			 "KNIT UNDERWEAR AND NIGHTWEAR MILLS"
			when "2257"
			 "WEFT KNIT FABRIC MILLS"
			when "2258"
			 "LACE AND WARP KNIT FABRIC MILLS"
			when "2259"
			 "KNITTING MILLS, NOT ELSEWHERE CLASSIFIED"
			when "2261"
			 "FINISHERS OF BROADWOVEN FABRICS OF COTTON"
			when "2262"
			 "FINISHERS OF BROADWOVEN FABRICS OF MANMADE FIBER AND SILK"
			when "2269"
			 "FINISHERS OF TEXTILES, NOT ELSEWHERE CLASSIFIED"
			when "2273"
			 "CARPETS AND RUGS"
			when "2281"
			 "YARN SPINNING MILLS"
			when "2282"
			 "YARN TEXTURIZING, THROWING, TWISTING, AND WINDING MILLS"
			when "2282"
			 "ACETATE FILAMENT YARN: THROWING, TWISTING, WINDING, OR SPOOLING"
			when "2284"
			 "THREAD MILLS"
			when "2295"
			 "COATED FABRICS, NOT RUBBERIZED"
			when "2296"
			 "TIRE CORD AND FABRICS"
			when "2297"
			 "NONWOVEN FABRICS"
			when "2298"
			 "CORDAGE AND TWINE"
			when "2299"
			 "TEXTILE GOODS, NOT ELSEWHERE CLASSIFIED"
			when "2311"
			 "MEN'S AND BOYS' SUITS, COATS, AND OVERCOATS"
			when "2321"
			 "MEN'S AND BOYS' SHIRTS, EXCEPT WORK SHIRTS"
			when "2322"
			 "MEN'S AND BOYS' UNDERWEAR AND NIGHTWEAR"
			when "2323"
			 "MEN'S AND BOYS' NECKWEAR"
			when "2325"
			 "MEN'S AND BOYS' SEPARATE TROUSERS AND SLACKS"
			when "2326"
			 "MEN'S AND BOYS' WORK CLOTHING"
			when "2329"
			 "MEN'S AND BOYS' CLOTHING, NOT ELSEWHERE CLASSIFIED"
			when "2331"
			 "WOMEN'S, MISSES', AND JUNIORS' BLOUSES AND SHIRTS"
			when "2335"
			 "WOMEN'S, MISSES', AND JUNIORS' DRESSES"
			when "2337"
			 "WOMEN'S, MISSES', AND JUNIORS' SUITS, SKIRTS, AND COATS"
			when "2339"
			 "WOMEN'S, MISSES', AND JUNIORS' OUTERWEAR, NOT ELSEWHERE CLASSIFIE"
			when "2341"
			 "WOMEN'S, MISSES', CHILDREN'S, AND INFANTS' UNDERWEAR AND NIGHTWEA"
			when "2342"
			 "BRASSIERES, GIRDLES, AND ALLIED GARMENTS"
			when "2353"
			 "HATS, CAPS, AND MILLINERY"
			when "2361"
			 "GIRLS', CHILDREN'S, AND INFANTS' DRESSES, BLOUSES, AND SHIRTS"
			when "2369"
			 "GIRLS', CHILDREN'S, AND INFANTS' OUTERWEAR, NOT ELSEWHERE CLASSIF"
			when "2371"
			 "FUR GOODS"
			when "2381"
			 "DRESS AND WORK GLOVES, EXCEPT KNIT AND ALL-LEATHER"
			when "2384"
			 "ROBES AND DRESSING GOWNS"
			when "2385"
			 "WATERPROOF OUTERWEAR"
			when "2386"
			 "LEATHER AND SHEEP-LINED CLOTHING"
			when "2387"
			 "APPAREL BELTS"
			when "2389"
			 "APPAREL AND ACCESSORIES, NOT ELSEWHERE CLASSIFIED"
			when "2391"
			 "CURTAINS AND DRAPERIES"
			when "2392"
			 "HOUSEFURNISHINGS, EXCEPT CURTAINS AND DRAPERIES"
			when "2393"
			 "TEXTILE BAGS"
			when "2394"
			 "CANVAS AND RELATED PRODUCTS"
			when "2395"
			 "PLEATING, DECORATIVE AND NOVELTY STITCHING, AND TUCKING FOR THE T"
			when "2396"
			 "AUTOMOTIVE TRIMMINGS, APPAREL FINDINGS, AND RELATED PRODUCTS"
			when "2397"
			 "SCHIFFLI MACHINE EMBROIDERIES"
			when "2399"
			 "FABRICATED TEXTILE PRODUCTS, NOT ELSEWHERE CLASSIFIED"
			when "2411"
			 "LOGGING"
			when "2421"
			 "SAWMILLS AND PLANING MILLS, GENERAL"
			when "2426"
			 "HARDWOOD DIMENSION AND FLOORING MILLS"
			when "2429"
			 "SPECIAL PRODUCT SAWMILLS, NOT ELSEWHERE CLASSIFIED"
			when "2431"
			 "MILLWORK"
			when "2434"
			 "WOOD KITCHEN CABINETS"
			when "2435"
			 "HARDWOOD VENEER AND PLYWOOD"
			when "2436"
			 "SOFTWOOD VENEER AND PLYWOOD"
			when "2439"
			 "STRUCTURAL WOOD MEMBERS, NOT ELSEWHERE CLASSIFIED"
			when "2441"
			 "NAILED AND LOCK CORNER WOOD BOXES AND SHOOK"
			when "2448"
			 "WOOD PALLETS AND SKIDS"
			when "2449"
			 "WOOD CONTAINERS, NOT ELSEWHERE CLASSIFIED"
			when "2451"
			 "MOBILE HOMES"
			when "2452"
			 "PREFABRICATED WOOD BUILDINGS AND COMPONENTS"
			when "2491"
			 "WOOD PRESERVING"
			when "2493"
			 "RECONSTITUTED WOOD PRODUCTS"
			when "2499"
			 "WOOD PRODUCTS, NOT ELSEWHERE CLASSIFIED"
			when "2511"
			 "WOOD HOUSEHOLD FURNITURE, EXCEPT UPHOLSTERED"
			when "2512"
			 "WOOD HOUSEHOLD FURNITURE, UPHOLSTERED"
			when "2514"
			 "METAL HOUSEHOLD FURNITURE"
			when "2515"
			 "MATTRESSES, FOUNDATIONS, AND CONVERTIBLE BEDS"
			when "2517"
			 "WOOD TELEVISION, RADIO, PHONOGRAPH, AND SEWING MACHINE CABINETS"
			when "2519"
			 "HOUSEHOLD FURNITURE, NOT ELSEWHERE CLASSIFIED"
			when "2521"
			 "WOOD OFFICE FURNITURE"
			when "2522"
			 "OFFICE FURNITURE, EXCEPT WOOD"
			when "2531"
			 "PUBLIC BUILDING AND RELATED FURNITURE"
			when "2541"
			 "WOOD OFFICE AND STORE FIXTURES, PARTITIONS, SHELVING, AND LOCKERS"
			when "2542"
			 "OFFICE AND STORE FIXTURES, PARTITIONS, SHELVING, AND LOCKERS, EXC"
			when "2591"
			 "DRAPERY HARDWARE AND WINDOW BLINDS AND SHADES"
			when "2599"
			 "FURNITURE AND FIXTURES, NOT ELSEWHERE CLASSIFIED"
			when "2611"
			 "PULP MILLS"
			when "2621"
			 "PAPER MILLS"
			when "2631"
			 "PAPERBOARD MILLS"
			when "2652"
			 "SETUP PAPERBOARD BOXES"
			when "2653"
			 "CORRUGATED AND SOLID FIBER BOXES"
			when "2655"
			 "FIBER CANS, TUBES, DRUMS, AND SIMILAR PRODUCTS"
			when "2656"
			 "SANITARY FOOD CONTAINERS, EXCEPT FOLDING"
			when "2657"
			 "FOLDING PAPERBOARD BOXES, INCLUDING SANITARY"
			when "2671"
			 "PACKAGING PAPER AND PLASTICS FILM, COATED AND LAMINATED"
			when "2672"
			 "COATED AND LAMINATED PAPER, NOT ELSEWHERE CLASSIFIED"
			when "2673"
			 "PLASTICS, FOIL, AND COATED PAPER BAGS"
			when "2674"
			 "UNCOATED PAPER AND MULTIWALL BAGS"
			when "2675"
			 "DIE-CUT PAPER AND PAPERBOARD AND CARDBOARD"
			when "2676"
			 "SANITARY PAPER PRODUCTS"
			when "2677"
			 "ENVELOPES"
			when "2678"
			 "STATIONERY, TABLETS, AND RELATED PRODUCTS"
			when "2679"
			 "CONVERTED PAPER AND PAPERBOARD PRODUCTS, NOT ELSEWHERE CLASSIFIED"
			when "2711"
			 "NEWSPAPERS: PUBLISHING, OR PUBLISHING AND PRINTING"
			when "2721"
			 "PERIODICALS: PUBLISHING, OR PUBLISHING AND PRINTING"
			when "2731"
			 "BOOKS: PUBLISHING, OR PUBLISHING AND PRINTING"
			when "2732"
			 "BOOK PRINTING"
			when "2741"
			 "MISCELLANEOUS PUBLISHING"
			when "2752"
			 "COMMERCIAL PRINTING, LITHOGRAPHIC"
			when "2754"
			 "COMMERCIAL PRINTING, GRAVURE"
			when "2759"
			 "COMMERCIAL PRINTING, NOT ELSEWHERE CLASSIFIED"
			when "2761"
			 "MANIFOLD BUSINESS FORMS"
			when "2771"
			 "GREETING CARDS"
			when "2782"
			 "BLANKBOOKS, LOOSELEAF BINDERS AND DEVICES"
			when "2789"
			 "BOOKBINDING AND RELATED WORK"
			when "2791"
			 "TYPESETTING"
			when "2796"
			 "PLATEMAKING AND RELATED SERVICES"
			when "2812"
			 "ALKALIES AND CHLORINE"
			when "2813"
			 "INDUSTRIAL GASES"
			when "2816"
			 "INORGANIC PIGMENTS"
			when "2819"
			 "INDUSTRIAL INORGANIC CHEMICALS, NOT ELSEWHERE CLASSIFIED"
			when "2821"
			 "PLASTICS MATERIALS, SYNTHETIC RESINS, AND NONVULCANIZABLE ELASTOM"
			when "2822"
			 "SYNTHETIC RUBBER (VULCANIZABLE ELASTOMERS)"
			when "2823"
			 "CELLULOSIC MANMADE FIBERS"
			when "2824"
			 "MANMADE ORGANIC FIBERS, EXCEPT CELLULOSIC"
			when "2833"
			 "MEDICINAL CHEMICALS AND BOTANICAL PRODUCTS"
			when "2834"
			 "PHARMACEUTICAL PREPARATIONS"
			when "2835"
			 "IN VITRO AND IN VIVO DIAGNOSTIC SUBSTANCES"
			when "2836"
			 "BIOLOGICAL PRODUCTS, EXCEPT DIAGNOSTIC SUBSTANCES"
			when "2841"
			 "SOAP AND OTHER DETERGENTS, EXCEPT SPECIALTY CLEANERS"
			when "2842"
			 "SPECIALTY CLEANING, POLISHING, AND SANITATION PREPARATIONS"
			when "2843"
			 "SURFACE ACTIVE AGENTS, FINISHING AGENTS, SULFONATED OILS, AND ASS"
			when "2844"
			 "PERFUMES, COSMETICS, AND OTHER TOILET PREPARATIONS"
			when "2851"
			 "PAINTS, VARNISHES, LACQUERS, ENAMELS, AND ALLIED PRODUCTS"
			when "2861"
			 "GUM AND WOOD CHEMICALS"
			when "2865"
			 "CYCLIC ORGANIC CRUDES AND INTERMEDIATES, AND ORGANIC DYES AND PIG"
			when "2869"
			 "INDUSTRIAL ORGANIC CHEMICALS, NOT ELSEWHERE CLASSIFIED"
			when "2873"
			 "NITROGENOUS FERTILIZERS"
			when "2874"
			 "PHOSPHATIC FERTILIZERS"
			when "2875"
			 "FERTILIZERS, MIXING ONLY"
			when "2879"
			 "PESTICIDES AND AGRICULTURAL CHEMICALS, NOT ELSEWHERE CLASSIFIED"
			when "2891"
			 "ADHESIVES AND SEALANTS"
			when "2892"
			 "EXPLOSIVES"
			when "2893"
			 "PRINTING INK"
			when "2895"
			 "CARBON BLACK"
			when "2899"
			 "CHEMICALS AND CHEMICAL PREPARATIONS, NOT ELSEWHERE CLASSIFIED"
			when "2911"
			 "PETROLEUM REFINING"
			when "2951"
			 "ASPHALT PAVING MIXTURES AND BLOCKS"
			when "2952"
			 "ASPHALT FELTS AND COATINGS"
			when "2992"
			 "LUBRICATING OILS AND GREASES"
			when "2999"
			 "PRODUCTS OF PETROLEUM AND COAL, NOT ELSEWHERE CLASSIFIED"
			when "3011"
			 "TIRES AND INNER TUBES"
			when "3021"
			 "RUBBER AND PLASTICS FOOTWEAR"
			when "3052"
			 "RUBBER AND PLASTICS HOSE AND BELTING"
			when "3053"
			 "GASKETS, PACKING, AND SEALING DEVICES"
			when "3061"
			 "MOLDED, EXTRUDED, AND LATHE-CUT MECHANICAL RUBBER GOODS"
			when "3069"
			 "FABRICATED RUBBER PRODUCTS, NOT ELSEWHERE CLASSIFIED"
			when "3081"
			 "UNSUPPORTED PLASTICS FILM AND SHEET"
			when "3082"
			 "UNSUPPORTED PLASTICS PROFILE SHAPES"
			when "3083"
			 "LAMINATED PLASTICS PLATE, SHEET, AND PROFILE SHAPES"
			when "3084"
			 "PLASTICS PIPE"
			when "3085"
			 "PLASTICS BOTTLES"
			when "3086"
			 "PLASTICS FOAM PRODUCTS"
			when "3087"
			 "CUSTOM COMPOUNDING OF PURCHASED PLASTICS RESINS"
			when "3088"
			 "PLASTICS PLUMBING FIXTURES"
			when "3089"
			 "PLASTICS PRODUCTS, NOT ELSEWHERE CLASSIFIED"
			when "3111"
			 "LEATHER TANNING AND FINISHING"
			when "3131"
			 "BOOT AND SHOE CUT STOCK AND FINDINGS"
			when "3142"
			 "HOUSE SLIPPERS"
			when "3143"
			 "MEN'S FOOTWEAR, EXCEPT ATHLETIC"
			when "3144"
			 "WOMEN'S FOOTWEAR, EXCEPT ATHLETIC"
			when "3149"
			 "FOOTWEAR, EXCEPT RUBBER, NOT ELSEWHERE CLASSIFIED"
			when "3151"
			 "LEATHER GLOVES AND MITTENS"
			when "3161"
			 "LUGGAGE"
			when "3171"
			 "WOMEN'S HANDBAGS AND PURSES"
			when "3172"
			 "PERSONAL LEATHER GOODS, EXCEPT WOMEN'S HANDBAGS AND PURSES"
			when "3199"
			 "LEATHER GOODS, NOT ELSEWHERE CLASSIFIED"
			when "3211"
			 "FLAT GLASS"
			when "3221"
			 "GLASS CONTAINERS"
			when "3229"
			 "PRESSED AND BLOWN GLASS AND GLASSWARE, NOT ELSEWHERE CLASSIFIED"
			when "3231"
			 "GLASS PRODUCTS, MADE OF PURCHASED GLASS"
			when "3241"
			 "CEMENT, HYDRAULIC"
			when "3251"
			 "BRICK AND STRUCTURAL CLAY TILE"
			when "3253"
			 "CERAMIC WALL AND FLOOR TILE"
			when "3255"
			 "CLAY REFRACTORIES"
			when "3259"
			 "STRUCTURAL CLAY PRODUCTS, NOT ELSEWHERE CLASSIFIED"
			when "3261"
			 "VITREOUS CHINA PLUMBING FIXTURES AND CHINA AND EARTHENWARE FITTIN"
			when "3262"
			 "VITREOUS CHINA TABLE AND KITCHEN ARTICLES"
			when "3263"
			 "FINE EARTHENWARE (WHITEWARE) TABLE AND KITCHEN ARTICLES"
			when "3264"
			 "PORCELAIN ELECTRICAL SUPPLIES"
			when "3269"
			 "POTTERY PRODUCTS, NOT ELSEWHERE CLASSIFIED"
			when "3271"
			 "CONCRETE BLOCK AND BRICK"
			when "3272"
			 "CONCRETE PRODUCTS, EXCEPT BLOCK AND BRICK"
			when "3273"
			 "READY-MIXED CONCRETE"
			when "3274"
			 "LIME"
			when "3275"
			 "GYPSUM PRODUCTS"
			when "3281"
			 "CUT STONE AND STONE PRODUCTS"
			when "3291"
			 "ABRASIVE PRODUCTS"
			when "3292"
			 "ASBESTOS PRODUCTS"
			when "3295"
			 "MINERALS AND EARTHS, GROUND OR OTHERWISE TREATED"
			when "3296"
			 "MINERAL WOOL"
			when "3297"
			 "NONCLAY REFRACTORIES"
			when "3299"
			 "NONMETALLIC MINERAL PRODUCTS, NOT ELSEWHERE CLASSIFIED"
			when "3312"
			 "STEEL WORKS, BLAST FURNACES (INCLUDING COKE OVENS), AND ROLLING M"
			when "3313"
			 "ELECTROMETALLURGICAL PRODUCTS, EXCEPT STEEL"
			when "3315"
			 "STEEL WIREDRAWING AND STEEL NAILS AND SPIKES"
			when "3316"
			 "COLD-ROLLED STEEL SHEET, STRIP, AND BARS"
			when "3317"
			 "STEEL PIPE AND TUBES"
			when "3321"
			 "GRAY AND DUCTILE IRON FOUNDRIES"
			when "3322"
			 "MALLEABLE IRON FOUNDRIES"
			when "3324"
			 "STEEL INVESTMENT FOUNDRIES"
			when "3325"
			 "STEEL FOUNDRIES, NOT ELSEWHERE CLASSIFIED"
			when "3331"
			 "PRIMARY SMELTING AND REFINING OF COPPER"
			when "3334"
			 "PRIMARY PRODUCTION OF ALUMINUM"
			when "3339"
			 "PRIMARY SMELTING AND REFINING OF NONFERROUS METALS, EXCEPT COPPER"
			when "3341"
			 "SECONDARY SMELTING AND REFINING OF NONFERROUS METALS"
			when "3351"
			 "ROLLING, DRAWING, AND EXTRUDING OF COPPER"
			when "3353"
			 "ALUMINUM SHEET, PLATE, AND FOIL"
			when "3354"
			 "ALUMINUM EXTRUDED PRODUCTS"
			when "3355"
			 "ALUMINUM ROLLING AND DRAWING, NOT ELSEWHERE CLASSIFIED"
			when "3356"
			 "ROLLING, DRAWING, AND EXTRUDING OF NONFERROUS METALS, EXCEPT COPP"
			when "3357"
			 "DRAWING AND INSULATING OF NONFERROUS WIRE"
			when "3363"
			 "ALUMINUM DIE-CASTINGS"
			when "3364"
			 "NONFERROUS DIE-CASTINGS, EXCEPT ALUMINUM"
			when "3365"
			 "ALUMINUM FOUNDRIES"
			when "3366"
			 "COPPER FOUNDRIES"
			when "3369"
			 "NONFERROUS FOUNDRIES, EXCEPT ALUMINUM AND COPPER"
			when "3398"
			 "METAL HEAT TREATING"
			when "3399"
			 "PRIMARY METAL PRODUCTS, NOT ELSEWHERE CLASSIFIED"
			when "3411"
			 "METAL CANS"
			when "3412"
			 "METAL SHIPPING BARRELS, DRUMS, KEGS, AND PAILS"
			when "3421"
			 "CUTLERY"
			when "3423"
			 "HAND AND EDGE TOOLS, EXCEPT MACHINE TOOLS AND HANDSAWS"
			when "3425"
			 "SAW BLADES AND HANDSAWS"
			when "3429"
			 "HARDWARE, NOT ELSEWHERE CLASSIFIED"
			when "3431"
			 "ENAMELED IRON AND METAL SANITARY WARE"
			when "3432"
			 "PLUMBING FIXTURE FITTINGS AND TRIM"
			when "3433"
			 "HEATING EQUIPMENT, EXCEPT ELECTRIC AND WARM AIR FURNACES"
			when "3441"
			 "FABRICATED STRUCTURAL METAL"
			when "3442"
			 "METAL DOORS, SASH, FRAMES, MOLDING, AND TRIM"
			when "3443"
			 "FABRICATED PLATE WORK (BOILER SHOPS)"
			when "3444"
			 "SHEET METALWORK"
			when "3446"
			 "ARCHITECTURAL AND ORNAMENTAL METALWORK"
			when "3448"
			 "PREFABRICATED METAL BUILDINGS AND COMPONENTS"
			when "3449"
			 "MISCELLANEOUS STRUCTURAL METALWORK"
			when "3451"
			 "SCREW MACHINE PRODUCTS"
			when "3452"
			 "BOLTS, NUTS, SCREWS, RIVETS, AND WASHERS"
			when "3462"
			 "IRON AND STEEL FORGINGS"
			when "3463"
			 "NONFERROUS FORGINGS"
			when "3465"
			 "AUTOMOTIVE STAMPINGS"
			when "3466"
			 "CROWNS AND CLOSURES"
			when "3469"
			 "METAL STAMPINGS, NOT ELSEWHERE CLASSIFIED"
			when "3471"
			 "ELECTROPLATING, PLATING, POLISHING, ANODIZING, AND COLORING"
			when "3479"
			 "COATING, ENGRAVING, AND ALLIED SERVICES, NOT ELSEWHERE CLASSIFIED"
			when "3482"
			 "SMALL ARMS AMMUNITION"
			when "3483"
			 "AMMUNITION, EXCEPT FOR SMALL ARMS"
			when "3484"
			 "SMALL ARMS"
			when "3489"
			 "ORDNANCE AND ACCESSORIES, NOT ELSEWHERE CLASSIFIED"
			when "3491"
			 "INDUSTRIAL VALVES"
			when "3492"
			 "FLUID POWER VALVES AND HOSE FITTINGS"
			when "3493"
			 "STEEL SPRINGS, EXCEPT WIRE"
			when "3494"
			 "VALVES AND PIPE FITTINGS, NOT ELSEWHERE CLASSIFIED"
			when "3495"
			 "WIRE SPRINGS"
			when "3496"
			 "MISCELLANEOUS FABRICATED WIRE PRODUCTS"
			when "3497"
			 "METAL FOIL AND LEAF"
			when "3498"
			 "FABRICATED PIPE AND PIPE FITTINGS"
			when "3499"
			 "FABRICATED METAL PRODUCTS, NOT ELSEWHERE CLASSIFIED"
			when "3511"
			 "STEAM, GAS, AND HYDRAULIC TURBINES, AND TURBINE GENERATOR SET UNI"
			when "3519"
			 "INTERNAL COMBUSTION ENGINES, NOT ELSEWHERE CLASSIFIED"
			when "3523"
			 "FARM MACHINERY AND EQUIPMENT"
			when "3524"
			 "LAWN AND GARDEN TRACTORS AND HOME LAWN AND GARDEN EQUIPMENT"
			when "3524"
			 "BLOWERS, RESIDENTIAL LAWN"
			when "3531"
			 "CONSTRUCTION MACHINERY AND EQUIPMENT"
			when "3532"
			 "MINING MACHINERY AND EQUIPMENT, EXCEPT OIL AND GAS FIELD MACHINER"
			when "3533"
			 "OIL AND GAS FIELD MACHINERY AND EQUIPMENT"
			when "3534"
			 "ELEVATORS AND MOVING STAIRWAYS"
			when "3535"
			 "CONVEYORS AND CONVEYING EQUIPMENT"
			when "3536"
			 "OVERHEAD TRAVELING CRANES, HOISTS, AND MONORAIL SYSTEMS"
			when "3537"
			 "INDUSTRIAL TRUCKS, TRACTORS, TRAILERS, AND STACKERS"
			when "3541"
			 "MACHINE TOOLS, METAL CUTTING TYPES"
			when "3542"
			 "MACHINE TOOLS, METAL FORMING TYPES"
			when "3543"
			 "INDUSTRIAL PATTERNS"
			when "3544"
			 "SPECIAL DIES AND TOOLS, DIE SETS, JIGS AND FIXTURES, AND INDUSTRI"
			when "3545"
			 "CUTTING TOOLS, MACHINE TOOL ACCESSORIES, AND MACHINISTS' PRECISIO"
			when "3546"
			 "POWER-DRIVEN HANDTOOLS"
			when "3547"
			 "ROLLING MILL MACHINERY AND EQUIPMENT"
			when "3548"
			 "ELECTRIC AND GAS WELDING AND SOLDERING EQUIPMENT"
			when "3549"
			 "METALWORKING MACHINERY, NOT ELSEWHERE CLASSIFIED"
			when "3552"
			 "TEXTILE MACHINERY"
			when "3553"
			 "WOODWORKING MACHINERY"
			when "3554"
			 "PAPER INDUSTRIES MACHINERY"
			when "3555"
			 "PRINTING TRADES MACHINERY AND EQUIPMENT"
			when "3556"
			 "FOOD PRODUCTS MACHINERY"
			when "3559"
			 "SPECIAL INDUSTRY MACHINERY, NOT ELSEWHERE CLASSIFIED"
			when "3561"
			 "PUMPS AND PUMPING EQUIPMENT"
			when "3562"
			 "BALL AND ROLLER BEARINGS"
			when "3563"
			 "AIR AND GAS COMPRESSORS"
			when "3564"
			 "INDUSTRIAL AND COMMERCIAL FANS AND BLOWERS AND AIR PURIFICATION E"
			when "3565"
			 "PACKAGING MACHINERY"
			when "3566"
			 "SPEED CHANGERS, INDUSTRIAL HIGH-SPEED DRIVES, AND GEARS"
			when "3567"
			 "INDUSTRIAL PROCESS FURNACES AND OVENS"
			when "3568"
			 "MECHANICAL POWER TRANSMISSION EQUIPMENT, NOT ELSEWHERE CLASSIFIED"
			when "3569"
			 "GENERAL INDUSTRIAL MACHINERY AND EQUIPMENT, NOT ELSEWHERE CLASSIF"
			when "3571"
			 "ELECTRONIC COMPUTERS"
			when "3572"
			 "COMPUTER STORAGE DEVICES"
			when "3575"
			 "COMPUTER TERMINALS"
			when "3577"
			 "COMPUTER PERIPHERAL EQUIPMENT, NOT ELSEWHERE CLASSIFIED"
			when "3578"
			 "CALCULATING AND ACCOUNTING MACHINES, EXCEPT ELECTRONIC COMPUTERS"
			when "3579"
			 "OFFICE MACHINES, NOT ELSEWHERE CLASSIFIED"
			when "3581"
			 "AUTOMATIC VENDING MACHINES"
			when "3582"
			 "COMMERCIAL LAUNDRY, DRYCLEANING, AND PRESSING MACHINES"
			when "3585"
			 "AIR-CONDITIONING AND WARM AIR HEATING EQUIPMENT AND COMMERCIAL AN"
			when "3586"
			 "MEASURING AND DISPENSING PUMPS"
			when "3589"
			 "SERVICE INDUSTRY MACHINERY, NOT ELSEWHERE CLASSIFIED"
			when "3592"
			 "CARBURETORS, PISTONS, PISTON RINGS, AND VALVES"
			when "3593"
			 "FLUID POWER CYLINDERS AND ACTUATORS"
			when "3594"
			 "FLUID POWER PUMPS AND MOTORS"
			when "3596"
			 "SCALES AND BALANCES, EXCEPT LABORATORY"
			when "3599"
			 "INDUSTRIAL AND COMMERCIAL MACHINERY AND EQUIPMENT, NOT ELSEWHERE"
			when "3612"
			 "POWER, DISTRIBUTION, AND SPECIALTY TRANSFORMERS"
			when "3613"
			 "SWITCHGEAR AND SWITCHBOARD APPARATUS"
			when "3621"
			 "MOTORS AND GENERATORS"
			when "3624"
			 "CARBON AND GRAPHITE PRODUCTS"
			when "3625"
			 "RELAYS AND INDUSTRIAL CONTROLS"
			when "3629"
			 "ELECTRICAL INDUSTRIAL APPARATUS, NOT ELSEWHERE CLASSIFIED"
			when "3631"
			 "HOUSEHOLD COOKING EQUIPMENT"
			when "3632"
			 "HOUSEHOLD REFRIGERATORS AND HOME AND FARM FREEZERS"
			when "3633"
			 "HOUSEHOLD LAUNDRY EQUIPMENT"
			when "3634"
			 "ELECTRIC HOUSEWARES AND FANS"
			when "3635"
			 "HOUSEHOLD VACUUM CLEANERS"
			when "3639"
			 "HOUSEHOLD APPLIANCES, NOT ELSEWHERE CLASSIFIED"
			when "3641"
			 "ELECTRIC LAMP BULBS AND TUBES"
			when "3643"
			 "CURRENT-CARRYING WIRING DEVICES"
			when "3644"
			 "NONCURRENT-CARRYING WIRING DEVICES"
			when "3645"
			 "RESIDENTIAL ELECTRIC LIGHTING FIXTURES"
			when "3646"
			 "COMMERCIAL, INDUSTRIAL, AND INSTITUTIONAL ELECTRIC LIGHTING FIXTU"
			when "3647"
			 "VEHICULAR LIGHTING EQUIPMENT"
			when "3648"
			 "LIGHTING EQUIPMENT, NOT ELSEWHERE CLASSIFIED"
			when "3651"
			 "HOUSEHOLD AUDIO AND VIDEO EQUIPMENT"
			when "3652"
			 "PHONOGRAPH RECORDS AND PRERECORDED AUDIO TAPES AND DISKS"
			when "3661"
			 "TELEPHONE AND TELEGRAPH APPARATUS"
			when "3663"
			 "RADIO AND TELEVISION BROADCASTING AND COMMUNICATIONS EQUIPMENT"
			when "3669"
			 "COMMUNICATIONS EQUIPMENT, NOT ELSEWHERE CLASSIFIED"
			when "3671"
			 "ELECTRON TUBES"
			when "3672"
			 "PRINTED CIRCUIT BOARDS"
			when "3674"
			 "SEMICONDUCTORS AND RELATED DEVICES"
			when "3675"
			 "ELECTRONIC CAPACITORS"
			when "3676"
			 "ELECTRONIC RESISTORS"
			when "3677"
			 "ELECTRONIC COILS, TRANSFORMERS, AND OTHER INDUCTORS"
			when "3678"
			 "ELECTRONIC CONNECTORS"
			when "3679"
			 "ELECTRONIC COMPONENTS, NOT ELSEWHERE CLASSIFIED"
			when "3691"
			 "STORAGE BATTERIES"
			when "3692"
			 "PRIMARY BATTERIES, DRY AND WET"
			when "3694"
			 "ELECTRICAL EQUIPMENT FOR INTERNAL COMBUSTION ENGINES"
			when "3695"
			 "MAGNETIC AND OPTICAL RECORDING MEDIA"
			when "3699"
			 "ELECTRICAL MACHINERY, EQUIPMENT, AND SUPPLIES, NOT ELSEWHERE CLAS"
			when "3711"
			 "MOTOR VEHICLES AND PASSENGER CAR BODIES"
			when "3713"
			 "TRUCK AND BUS BODIES"
			when "3714"
			 "MOTOR VEHICLE PARTS AND ACCESSORIES"
			when "3715"
			 "TRUCK TRAILERS"
			when "3716"
			 "MOTOR HOMES"
			when "3721"
			 "AIRCRAFT"
			when "3724"
			 "AIRCRAFT ENGINES AND ENGINE PARTS"
			when "3728"
			 "AIRCRAFT PARTS AND AUXILIARY EQUIPMENT, NOT ELSEWHERE CLASSIFIED"
			when "3731"
			 "SHIP BUILDING AND REPAIRING"
			when "3732"
			 "BOAT BUILDING AND REPAIRING"
			when "3743"
			 "RAILROAD EQUIPMENT"
			when "3751"
			 "MOTORCYCLES, BICYCLES, AND PARTS"
			when "3761"
			 "GUIDED MISSILES AND SPACE VEHICLES"
			when "3764"
			 "GUIDED MISSILE AND SPACE VEHICLE PROPULSION UNITS AND PROPULSION"
			when "3769"
			 "GUIDED MISSILE AND SPACE VEHICLE PARTS AND AUXILIARY EQUIPMENT, N"
			when "3792"
			 "TRAVEL TRAILERS AND CAMPERS"
			when "3795"
			 "TANKS AND TANK COMPONENTS"
			when "3799"
			 "TRANSPORTATION EQUIPMENT, NOT ELSEWHERE CLASSIFIED"
			when "3812"
			 "SEARCH, DETECTION, NAVIGATION, GUIDANCE, AERONAUTICAL, AND NAUTIC"
			when "3821"
			 "LABORATORY APPARATUS AND FURNITURE"
			when "3822"
			 "AUTOMATIC CONTROLS FOR REGULATING RESIDENTIAL AND COMMERCIAL ENVI"
			when "3823"
			 "INDUSTRIAL INSTRUMENTS FOR MEASUREMENT, DISPLAY, AND CONTROL OF P"
			when "3824"
			 "TOTALIZING FLUID METERS AND COUNTING DEVICES"
			when "3825"
			 "INSTRUMENTS FOR MEASURING AND TESTING OF ELECTRICITY AND ELECTRIC"
			when "3826"
			 "LABORATORY ANALYTICAL INSTRUMENTS"
			when "3827"
			 "OPTICAL INSTRUMENTS AND LENSES"
			when "3829"
			 "MEASURING AND CONTROLLING DEVICES, NOT ELSEWHERE CLASSIFIED"
			when "3841"
			 "SURGICAL AND MEDICAL INSTRUMENTS AND APPARATUS"
			when "3842"
			 "ORTHOPEDIC, PROSTHETIC, AND SURGICAL APPLIANCES AND SUPPLIES"
			when "3843"
			 "DENTAL EQUIPMENT AND SUPPLIES"
			when "3844"
			 "X-RAY APPARATUS AND TUBES AND RELATED IRRADIATION APPARATUS"
			when "3845"
			 "ELECTROMEDICAL AND ELECTROTHERAPEUTIC APPARATUS"
			when "3851"
			 "OPHTHALMIC GOODS"
			when "3861"
			 "PHOTOGRAPHIC EQUIPMENT AND SUPPLIES"
			when "3873"
			 "WATCHES, CLOCKS, CLOCKWORK OPERATED DEVICES, AND PARTS"
			when "3911"
			 "JEWELRY, PRECIOUS METAL"
			when "3914"
			 "SILVERWARE, PLATED WARE, AND STAINLESS STEEL WARE"
			when "3915"
			 "JEWELERS' FINDINGS AND MATERIALS, AND LAPIDARY WORK"
			when "3931"
			 "MUSICAL INSTRUMENTS"
			when "3942"
			 "DOLLS AND STUFFED TOYS"
			when "3944"
			 "GAMES, TOYS, AND CHILDREN'S VEHICLES, EXCEPT DOLLS AND BICYCLES"
			when "3949"
			 "SPORTING AND ATHLETIC GOODS, NOT ELSEWHERE CLASSIFIED"
			when "3951"
			 "PENS, MECHANICAL PENCILS, AND PARTS"
			when "3952"
			 "LEAD PENCILS, CRAYONS, AND ARTISTS' MATERIALS"
			when "3953"
			 "MARKING DEVICES"
			when "3955"
			 "CARBON PAPER AND INKED RIBBONS"
			when "3961"
			 "COSTUME JEWELRY AND COSTUME NOVELTIES, EXCEPT PRECIOUS METAL"
			when "3965"
			 "FASTENERS, BUTTONS, NEEDLES, AND PINS"
			when "3991"
			 "BROOMS AND BRUSHES"
			when "3993"
			 "SIGNS AND ADVERTISING SPECIALTIES"
			when "3995"
			 "BURIAL CASKETS"
			when "3996"
			 "LINOLEUM, ASPHALTED-FELT-BASE, AND OTHER HARD SURFACE FLOOR COVER"
			when "3999"
			 "MANUFACTURING INDUSTRIES, NOT ELSEWHERE CLASSIFIED"
			when "4011"
			 "RAILROADS, LINE-HAUL OPERATING"
			when "4013"
			 "RAILROAD SWITCHING AND TERMINAL ESTABLISHMENTS"
			when "4111"
			 "LOCAL AND SUBURBAN TRANSIT"
			when "4119"
			 "LOCAL PASSENGER TRANSPORTATION, NOT ELSEWHERE CLASSIFIED"
			when "4121"
			 "TAXICABS"
			when "4131"
			 "INTERCITY AND RURAL BUS TRANSPORTATION"
			when "4141"
			 "LOCAL BUS CHARTER SERVICE"
			when "4142"
			 "BUS CHARTER SERVICE, EXCEPT LOCAL"
			when "4151"
			 "SCHOOL BUSES"
			when "4173"
			 "TERMINAL AND SERVICE FACILITIES FOR MOTOR VEHICLE PASSENGER TRANS"
			when "4212"
			 "LOCAL TRUCKING WITHOUT STORAGE"
			when "4213"
			 "TRUCKING, EXCEPT LOCAL"
			when "4214"
			 "LOCAL TRUCKING WITH STORAGE"
			when "4215"
			 "COURIER SERVICES, EXCEPT BY AIR"
			when "4221"
			 "FARM PRODUCT WAREHOUSING AND STORAGE"
			when "4222"
			 "REFRIGERATED WAREHOUSING AND STORAGE"
			when "4225"
			 "GENERAL WAREHOUSING AND STORAGE"
			when "4226"
			 "SPECIAL WAREHOUSING AND STORAGE, NOT ELSEWHERE CLASSIFIED"
			when "4231"
			 "TERMINAL AND JOINT TERMINAL MAINTENANCE FACILITIES FOR MOTOR FREI"
			when "4311"
			 "UNITED STATES POSTAL SERVICE"
			when "4412"
			 "DEEP SEA FOREIGN TRANSPORTATION OF FREIGHT"
			when "4424"
			 "DEEP SEA DOMESTIC TRANSPORTATION OF FREIGHT"
			when "4432"
			 "FREIGHT TRANSPORTATION ON THE GREAT LAKES&die;ST. LAWRENCE SEAWAY"
			when "4449"
			 "WATER TRANSPORTATION OF FREIGHT, NOT ELSEWHERE CLASSIFIED"
			when "4481"
			 "DEEP SEA TRANSPORTATION OF PASSENGERS, EXCEPT BY FERRY"
			when "4482"
			 "FERRIES"
			when "4489"
			 "WATER TRANSPORTATION OF PASSENGERS, NOT ELSEWHERE CLASSIFIED"
			when "4491"
			 "MARINE CARGO HANDLING"
			when "4492"
			 "TOWING AND TUGBOAT SERVICES"
			when "4493"
			 "MARINAS"
			when "4499"
			 "WATER TRANSPORTATION SERVICES, NOT ELSEWHERE CLASSIFIED"
			when "4512"
			 "AIR TRANSPORTATION, SCHEDULED"
			when "4513"
			 "AIR COURIER SERVICES"
			when "4522"
			 "AIR TRANSPORTATION, NONSCHEDULED"
			when "4581"
			 "AIRPORTS, FLYING FIELDS, AND AIRPORT TERMINAL SERVICES"
			when "4612"
			 "CRUDE PETROLEUM PIPELINES"
			when "4613"
			 "REFINED PETROLEUM PIPELINES"
			when "4619"
			 "PIPELINES, NOT ELSEWHERE CLASSIFIED"
			when "4724"
			 "TRAVEL AGENCIES"
			when "4725"
			 "TOUR OPERATORS"
			when "4729"
			 "ARRANGEMENT OF PASSENGER TRANSPORTATION, NOT ELSEWHERE CLASSIFIED"
			when "4731"
			 "ARRANGEMENT OF TRANSPORTATION OF FREIGHT AND CARGO"
			when "4741"
			 "RENTAL OF RAILROAD CARS"
			when "4783"
			 "PACKING AND CRATING"
			when "4785"
			 "FIXED FACILITIES AND INSPECTION AND WEIGHING SERVICES FOR MOTOR V"
			when "4785"
			 "CARGO CHECKERS AND SURVEYORS, MARINE"
			when "4789"
			 "TRANSPORTATION SERVICES, NOT ELSEWHERE CLASSIFIED"
			when "4812"
			 "RADIOTELEPHONE COMMUNICATIONS"
			when "4813"
			 "TELEPHONE COMMUNICATIONS, EXCEPT RADIOTELEPHONE"
			when "4822"
			 "TELEGRAPH AND OTHER MESSAGE COMMUNICATIONS"
			when "4832"
			 "RADIO BROADCASTING STATIONS"
			when "4833"
			 "TELEVISION BROADCASTING STATIONS"
			when "4841"
			 "CABLE AND OTHER PAY TELEVISION SERVICES"
			when "4899"
			 "COMMUNICATIONS SERVICES, NOT ELSEWHERE CLASSIFIED"
			when "4911"
			 "ELECTRIC SERVICES"
			when "4922"
			 "NATURAL GAS TRANSMISSION"
			when "4923"
			 "NATURAL GAS TRANSMISSION AND DISTRIBUTION"
			when "4924"
			 "NATURAL GAS DISTRIBUTION"
			when "4925"
			 "MIXED, MANUFACTURED, OR LIQUEFIED PETROLEUM GAS PRODUCTION AND/OR"
			when "4931"
			 "ELECTRIC AND OTHER SERVICES COMBINED"
			when "4932"
			 "GAS AND OTHER SERVICES COMBINED"
			when "4939"
			 "COMBINATION UTILITIES, NOT ELSEWHERE CLASSIFIED"
			when "4941"
			 "WATER SUPPLY"
			when "4952"
			 "SEWERAGE SYSTEMS"
			when "4953"
			 "REFUSE SYSTEMS"
			when "4959"
			 "SANITARY SERVICES, NOT ELSEWHERE CLASSIFIED"
			when "4961"
			 "STEAM AND AIR-CONDITIONING SUPPLY"
			when "4971"
			 "IRRIGATION SYSTEMS"
			when "5012"
			 "AUTOMOBILES AND OTHER MOTOR VEHICLES"
			when "5013"
			 "MOTOR VEHICLE SUPPLIES AND NEW PARTS"
			when "5014"
			 "TIRES AND TUBES"
			when "5015"
			 "MOTOR VEHICLE PARTS, USED"
			when "5021"
			 "FURNITURE"
			when "5023"
			 "HOMEFURNISHINGS"
			when "5031"
			 "LUMBER, PLYWOOD, MILLWORK, AND WOOD PANELS"
			when "5032"
			 "BRICK, STONE, AND RELATED CONSTRUCTION MATERIALS"
			when "5033"
			 "ROOFING, SIDING, AND INSULATION MATERIALS"
			when "5039"
			 "CONSTRUCTION MATERIALS, NOT ELSEWHERE CLASSIFIED"
			when "5043"
			 "PHOTOGRAPHIC EQUIPMENT AND SUPPLIES"
			when "5044"
			 "OFFICE EQUIPMENT"
			when "5045"
			 "COMPUTERS AND COMPUTER PERIPHERAL EQUIPMENT AND SOFTWARE"
			when "5046"
			 "COMMERCIAL EQUIPMENT, NOT ELSEWHERE CLASSIFIED"
			when "5047"
			 "MEDICAL, DENTAL, AND HOSPITAL EQUIPMENT AND SUPPLIES"
			when "5048"
			 "OPHTHALMIC GOODS"
			when "5049"
			 "PROFESSIONAL EQUIPMENT AND SUPPLIES, NOT ELSEWHERE CLASSIFIED"
			when "5051"
			 "METALS SERVICE CENTERS AND OFFICES"
			when "5052"
			 "COAL AND OTHER MINERALS AND ORES"
			when "5063"
			 "ELECTRICAL APPARATUS AND EQUIPMENT, WIRING SUPPLIES, AND CONSTRUC"
			when "5064"
			 "ELECTRICAL APPLIANCES, TELEVISION AND RADIO SETS"
			when "5065"
			 "ELECTRONIC PARTS AND EQUIPMENT, NOT ELSEWHERE CLASSIFIED"
			when "5072"
			 "HARDWARE"
			when "5074"
			 "PLUMBING AND HEATING EQUIPMENT AND SUPPLIES (HYDRONICS)"
			when "5075"
			 "WARM AIR HEATING AND AIR-CONDITIONING EQUIPMENT AND SUPPLIES"
			when "5078"
			 "REFRIGERATION EQUIPMENT AND SUPPLIES"
			when "5082"
			 "CONSTRUCTION AND MINING (EXCEPT PETROLEUM) MACHINERY AND EQUIPMEN"
			when "5083"
			 "FARM AND GARDEN MACHINERY AND EQUIPMENT"
			when "5084"
			 "INDUSTRIAL MACHINERY AND EQUIPMENT"
			when "5085"
			 "INDUSTRIAL SUPPLIES"
			when "5087"
			 "SERVICE ESTABLISHMENT EQUIPMENT AND SUPPLIES"
			when "5088"
			 "TRANSPORTATION EQUIPMENT AND SUPPLIES, EXCEPT MOTOR VEHICLES"
			when "5091"
			 "SPORTING AND RECREATIONAL GOODS AND SUPPLIES"
			when "5092"
			 "TOYS AND HOBBY GOODS AND SUPPLIES"
			when "5093"
			 "SCRAP AND WASTE MATERIALS"
			when "5094"
			 "JEWELRY, WATCHES, PRECIOUS STONES, AND PRECIOUS METALS"
			when "5099"
			 "DURABLE GOODS, NOT ELSEWHERE CLASSIFIED"
			when "5111"
			 "PRINTING AND WRITING PAPER"
			when "5112"
			 "STATIONERY AND OFFICE SUPPLIES"
			when "5113"
			 "INDUSTRIAL AND PERSONAL SERVICE PAPER"
			when "5122"
			 "DRUGS, DRUG PROPRIETARIES, AND DRUGGISTS' SUNDRIES"
			when "5131"
			 "PIECE GOODS, NOTIONS, AND OTHER DRY GOODS"
			when "5136"
			 "MEN'S AND BOYS' CLOTHING AND FURNISHINGS"
			when "5137"
			 "WOMEN'S, CHILDREN'S, AND INFANTS' CLOTHING AND ACCESSORIES"
			when "5139"
			 "FOOTWEAR"
			when "5141"
			 "GROCERIES, GENERAL LINE"
			when "5142"
			 "PACKAGED FROZEN FOODS"
			when "5143"
			 "DAIRY PRODUCTS, EXCEPT DRIED OR CANNED"
			when "5144"
			 "POULTRY AND POULTRY PRODUCTS"
			when "5145"
			 "CONFECTIONERY"
			when "5146"
			 "FISH AND SEAFOODS"
			when "5147"
			 "MEATS AND MEAT PRODUCTS"
			when "5148"
			 "FRESH FRUITS AND VEGETABLES"
			when "5149"
			 "GROCERIES AND RELATED PRODUCTS, NOT ELSEWHERE CLASSIFIED"
			when "5153"
			 "GRAIN AND FIELD BEANS"
			when "5154"
			 "LIVESTOCK"
			when "5159"
			 "FARM-PRODUCT RAW MATERIALS, NOT ELSEWHERE CLASSIFIED"
			when "5162"
			 "PLASTICS MATERIALS AND BASIC FORMS AND SHAPES"
			when "5169"
			 "CHEMICALS AND ALLIED PRODUCTS, NOT ELSEWHERE CLASSIFIED"
			when "5171"
			 "PETROLEUM BULK STATIONS AND TERMINALS"
			when "5172"
			 "PETROLEUM AND PETROLEUM PRODUCTS WHOLESALERS, EXCEPT BULK STATION"
			when "5181"
			 "BEER AND ALE"
			when "5182"
			 "WINE AND DISTILLED ALCOHOLIC BEVERAGES"
			when "5191"
			 "FARM SUPPLIES"
			when "5192"
			 "BOOKS, PERIODICALS, AND NEWSPAPERS"
			when "5193"
			 "FLOWERS, NURSERY STOCK, AND FLORISTS' SUPPLIES"
			when "5194"
			 "TOBACCO AND TOBACCO PRODUCTS"
			when "5198"
			 "PAINTS, VARNISHES, AND SUPPLIES"
			when "5199"
			 "NONDURABLE GOODS, NOT ELSEWHERE CLASSIFIED"
			when "5211"
			 "LUMBER AND OTHER BUILDING MATERIALS DEALERS"
			when "5231"
			 "PAINT, GLASS, AND WALLPAPER STORES"
			when "5251"
			 "HARDWARE STORES"
			when "5261"
			 "RETAIL NURSERIES, LAWN AND GARDEN SUPPLY STORES"
			when "5271"
			 "MOBILE HOME DEALERS"
			when "5311"
			 "DEPARTMENT STORES"
			when "5331"
			 "VARIETY STORES"
			when "5399"
			 "MISCELLANEOUS GENERAL MERCHANDISE STORES"
			when "5411"
			 "GROCERY STORES"
			when "5421"
			 "MEAT AND FISH (SEAFOOD) MARKETS, INCLUDING FREEZER PROVISIONERS"
			when "5431"
			 "FRUIT AND VEGETABLE MARKETS"
			when "5441"
			 "CANDY, NUT, AND CONFECTIONERY STORES"
			when "5451"
			 "DAIRY PRODUCTS STORES"
			when "5461"
			 "RETAIL BAKERIES"
			when "5499"
			 "MISCELLANEOUS FOOD STORES"
			when "5511"
			 "MOTOR VEHICLE DEALERS (NEW AND USED)"
			when "5521"
			 "MOTOR VEHICLE DEALERS (USED ONLY)"
			when "5531"
			 "AUTO AND HOME SUPPLY STORES"
			when "5541"
			 "GASOLINE SERVICE STATIONS"
			when "5551"
			 "BOAT DEALERS"
			when "5561"
			 "RECREATIONAL VEHICLE DEALERS"
			when "5571"
			 "MOTORCYCLE DEALERS"
			when "5599"
			 "AUTOMOTIVE DEALERS, NOT ELSEWHERE CLASSIFIED"
			when "5611"
			 "MEN'S AND BOYS' CLOTHING AND ACCESSORY STORES"
			when "5621"
			 "WOMEN'S CLOTHING STORES"
			when "5632"
			 "WOMEN'S ACCESSORY AND SPECIALTY STORES"
			when "5641"
			 "CHILDREN'S AND INFANTS' WEAR STORES"
			when "5651"
			 "FAMILY CLOTHING STORES"
			when "5661"
			 "SHOE STORES"
			when "5699"
			 "MISCELLANEOUS APPAREL AND ACCESSORY STORES"
			when "5712"
			 "FURNITURE STORES"
			when "5713"
			 "FLOOR COVERING STORES"
			when "5714"
			 "DRAPERY, CURTAIN, AND UPHOLSTERY STORES"
			when "5719"
			 "MISCELLANEOUS HOMEFURNISHINGS STORES"
			when "5722"
			 "HOUSEHOLD APPLIANCE STORES"
			when "5731"
			 "RADIO, TELEVISION, AND CONSUMER ELECTRONICS STORES"
			when "5734"
			 "COMPUTER AND COMPUTER SOFTWARE STORES"
			when "5735"
			 "RECORD AND PRERECORDED TAPE STORES"
			when "5736"
			 "MUSICAL INSTRUMENT STORES"
			when "5812"
			 "EATING PLACES"
			when "5813"
			 "DRINKING PLACES (ALCOHOLIC BEVERAGES)"
			when "5912"
			 "DRUG STORES AND PROPRIETARY STORES"
			when "5921"
			 "LIQUOR STORES"
			when "5932"
			 "USED MERCHANDISE STORES"
			when "5941"
			 "SPORTING GOODS STORES AND BICYCLE SHOPS"
			when "5942"
			 "BOOK STORES"
			when "5943"
			 "STATIONERY STORES"
			when "5944"
			 "JEWELRY STORES"
			when "5945"
			 "HOBBY, TOY, AND GAME SHOPS"
			when "5946"
			 "CAMERA AND PHOTOGRAPHIC SUPPLY STORES"
			when "5947"
			 "GIFT, NOVELTY, AND SOUVENIR SHOPS"
			when "5948"
			 "LUGGAGE AND LEATHER GOODS STORES"
			when "5949"
			 "SEWING, NEEDLEWORK, AND PIECE GOODS STORES"
			when "5961"
			 "CATALOG AND MAIL-ORDER HOUSES"
			when "5962"
			 "AUTOMATIC MERCHANDISING MACHINE OPERATORS"
			when "5963"
			 "DIRECT SELLING ESTABLISHMENTS"
			when "5983"
			 "FUEL OIL DEALERS"
			when "5984"
			 "LIQUEFIED PETROLEUM GAS (BOTTLED GAS) DEALERS"
			when "5989"
			 "FUEL DEALERS, NOT ELSEWHERE CLASSIFIED"
			when "5992"
			 "FLORISTS"
			when "5993"
			 "TOBACCO STORES AND STANDS"
			when "5994"
			 "NEWS DEALERS AND NEWSSTANDS"
			when "5995"
			 "OPTICAL GOODS STORES"
			when "5999"
			 "MISCELLANEOUS RETAIL STORES, NOT ELSEWHERE CLASSIFIED"
			when "6011"
			 "FEDERAL RESERVE BANKS"
			when "6019"
			 "CENTRAL RESERVE DEPOSITORY INSTITUTIONS, NOT ELSEWHERE CLASSIFIED"
			when "6021"
			 "NATIONAL COMMERCIAL BANKS"
			when "6022"
			 "STATE COMMERCIAL BANKS"
			when "6029"
			 "COMMERCIAL BANKS, NOT ELSEWHERE CLASSIFIED"
			when "6035"
			 "SAVINGS INSTITUTIONS, FEDERALLY CHARTERED"
			when "6036"
			 "SAVINGS INSTITUTIONS, NOT FEDERALLY CHARTERED"
			when "6061"
			 "CREDIT UNIONS, FEDERALLY CHARTERED"
			when "6062"
			 "CREDIT UNIONS, NOT FEDERALLY CHARTERED"
			when "6081"
			 "BRANCHES AND AGENCIES OF FOREIGN BANKS"
			when "6082"
			 "FOREIGN TRADE AND INTERNATIONAL BANKING INSTITUTIONS"
			when "6091"
			 "NONDEPOSIT TRUST FACILITIES"
			when "6099"
			 "FUNCTIONS RELATED TO DEPOSITORY BANKING, NOT ELSEWHERE CLASSIFIED"
			when "6111"
			 "FEDERAL AND FEDERALLY-SPONSORED CREDIT AGENCIES"
			when "6141"
			 "PERSONAL CREDIT INSTITUTIONS"
			when "6153"
			 "SHORT-TERM BUSINESS CREDIT INSTITUTIONS, EXCEPT AGRICULTURAL"
			when "6159"
			 "MISCELLANEOUS BUSINESS CREDIT INSTITUTIONS"
			when "6162"
			 "MORTGAGE BANKERS AND LOAN CORRESPONDENTS"
			when "6163"
			 "LOAN BROKERS"
			when "6211"
			 "SECURITY BROKERS, DEALERS, AND FLOTATION COMPANIES"
			when "6221"
			 "COMMODITY CONTRACTS BROKERS AND DEALERS"
			when "6231"
			 "SECURITY AND COMMODITY EXCHANGES"
			when "6282"
			 "INVESTMENT ADVICE"
			when "6289"
			 "SERVICES ALLIED WITH THE EXCHANGE OF SECURITIES OR COMMODITIES, N"
			when "6311"
			 "LIFE INSURANCE"
			when "6321"
			 "ACCIDENT AND HEALTH INSURANCE"
			when "6324"
			 "HOSPITAL AND MEDICAL SERVICE PLANS"
			when "6331"
			 "FIRE, MARINE, AND CASUALTY INSURANCE"
			when "6351"
			 "SURETY INSURANCE"
			when "6361"
			 "TITLE INSURANCE"
			when "6371"
			 "PENSION, HEALTH, AND WELFARE FUNDS"
			when "6399"
			 "INSURANCE CARRIERS, NOT ELSEWHERE CLASSIFIED"
			when "6411"
			 "INSURANCE AGENTS, BROKERS, AND SERVICE"
			when "6512"
			 "OPERATORS OF NONRESIDENTIAL BUILDINGS"
			when "6513"
			 "OPERATORS OF APARTMENT BUILDINGS"
			when "6514"
			 "OPERATORS OF DWELLINGS OTHER THAN APARTMENT BUILDINGS"
			when "6515"
			 "OPERATORS OF RESIDENTIAL MOBILE HOME SITES"
			when "6517"
			 "LESSORS OF RAILROAD PROPERTY"
			when "6519"
			 "LESSORS OF REAL PROPERTY, NOT ELSEWHERE CLASSIFIED"
			when "6531"
			 "REAL ESTATE AGENTS AND MANAGERS"
			when "6541"
			 "TITLE ABSTRACT OFFICES"
			when "6552"
			 "LAND SUBDIVIDERS AND DEVELOPERS, EXCEPT CEMETERIES"
			when "6553"
			 "CEMETERY SUBDIVIDERS AND DEVELOPERS"
			when "6712"
			 "OFFICES OF BANK HOLDING COMPANIES"
			when "6719"
			 "OFFICES OF HOLDING COMPANIES, NOT ELSEWHERE CLASSIFIED"
			when "6722"
			 "MANAGEMENT INVESTMENT OFFICES, OPEN-END"
			when "6726"
			 "UNIT INVESTMENT TRUSTS, FACE-AMOUNT CERTIFICATE OFFICES, AND CLOS"
			when "6732"
			 "EDUCATIONAL, RELIGIOUS, AND CHARITABLE TRUSTS"
			when "6733"
			 "TRUSTS, EXCEPT EDUCATIONAL, RELIGIOUS, AND CHARITABLE"
			when "6792"
			 "OIL ROYALTY TRADERS"
			when "6794"
			 "PATENT OWNERS AND LESSORS"
			when "6798"
			 "REAL ESTATE INVESTMENT TRUSTS"
			when "6799"
			 "INVESTORS, NOT ELSEWHERE CLASSIFIED"
			when "7011"
			 "HOTELS AND MOTELS"
			when "7021"
			 "ROOMING AND BOARDING HOUSES"
			when "7032"
			 "SPORTING AND RECREATIONAL CAMPS"
			when "7033"
			 "RECREATIONAL VEHICLE PARKS AND CAMPSITES"
			when "7041"
			 "ORGANIZATION HOTELS AND LODGING HOUSES, ON MEMBERSHIP BASIS"
			when "7211"
			 "POWER LAUNDRIES, FAMILY AND COMMERCIAL"
			when "7212"
			 "GARMENT PRESSING, AND AGENTS FOR LAUNDRIES AND DRYCLEANERS"
			when "7213"
			 "LINEN SUPPLY"
			when "7215"
			 "COIN-OPERATED LAUNDRIES AND DRYCLEANING"
			when "7216"
			 "DRYCLEANING PLANTS, EXCEPT RUG CLEANING"
			when "7217"
			 "CARPET AND UPHOLSTERY CLEANING"
			when "7218"
			 "INDUSTRIAL LAUNDERERS"
			when "7219"
			 "LAUNDRY AND GARMENT SERVICES, NOT ELSEWHERE CLASSIFIED"
			when "7221"
			 "PHOTOGRAPHIC STUDIOS, PORTRAIT"
			when "7231"
			 "BEAUTY SHOPS"
			when "7241"
			 "BARBER SHOPS"
			when "7251"
			 "SHOE REPAIR SHOPS AND SHOESHINE PARLORS"
			when "7261"
			 "FUNERAL SERVICE AND CREMATORIES"
			when "7291"
			 "TAX RETURN PREPARATION SERVICES"
			when "7299"
			 "MISCELLANEOUS PERSONAL SERVICES, NOT ELSEWHERE CLASSIFIED"
			when "7311"
			 "ADVERTISING AGENCIES"
			when "7312"
			 "OUTDOOR ADVERTISING SERVICES"
			when "7313"
			 "RADIO, TELEVISION, AND PUBLISHERS' ADVERTISING REPRESENTATIVES"
			when "7319"
			 "ADVERTISING, NOT ELSEWHERE CLASSIFIED"
			when "7322"
			 "ADJUSTMENT AND COLLECTION SERVICES"
			when "7323"
			 "CREDIT REPORTING SERVICES"
			when "7331"
			 "DIRECT MAIL ADVERTISING SERVICES"
			when "7334"
			 "PHOTOCOPYING AND DUPLICATING SERVICES"
			when "7335"
			 "COMMERCIAL PHOTOGRAPHY"
			when "7336"
			 "COMMERCIAL ART AND GRAPHIC DESIGN"
			when "7338"
			 "SECRETARIAL AND COURT REPORTING SERVICES"
			when "7342"
			 "DISINFECTING AND PEST CONTROL SERVICES"
			when "7349"
			 "BUILDING CLEANING AND MAINTENANCE SERVICES, NOT ELSEWHERE CLASSIF"
			when "7352"
			 "MEDICAL EQUIPMENT RENTAL AND LEASING"
			when "7353"
			 "HEAVY CONSTRUCTION EQUIPMENT RENTAL AND LEASING"
			when "7359"
			 "EQUIPMENT RENTAL AND LEASING, NOT ELSEWHERE CLASSIFIED"
			when "7361"
			 "EMPLOYMENT AGENCIES"
			when "7363"
			 "HELP SUPPLY SERVICES"
			when "7371"
			 "COMPUTER PROGRAMMING SERVICES"
			when "7372"
			 "PREPACKAGED SOFTWARE"
			when "7373"
			 "COMPUTER INTEGRATED SYSTEMS DESIGN"
			when "7374"
			 "COMPUTER PROCESSING AND DATA PREPARATION AND PROCESSING SERVICES"
			when "7375"
			 "INFORMATION RETRIEVAL SERVICES"
			when "7376"
			 "COMPUTER FACILITIES MANAGEMENT SERVICES"
			when "7377"
			 "COMPUTER RENTAL AND LEASING"
			when "7378"
			 "COMPUTER MAINTENANCE AND REPAIR"
			when "7379"
			 "COMPUTER RELATED SERVICES, NOT ELSEWHERE CLASSIFIED"
			when "7381"
			 "DETECTIVE, GUARD, AND ARMORED CAR SERVICES"
			when "7382"
			 "SECURITY SYSTEMS SERVICES"
			when "7383"
			 "NEWS SYNDICATES"
			when "7384"
			 "PHOTOFINISHING LABORATORIES"
			when "7389"
			 "BUSINESS SERVICES, NOT ELSEWHERE CLASSIFIED"
			when "7513"
			 "TRUCK RENTAL AND LEASING, WITHOUT DRIVERS"
			when "7514"
			 "PASSENGER CAR RENTAL"
			when "7515"
			 "PASSENGER CAR LEASING"
			when "7519"
			 "UTILITY TRAILER AND RECREATIONAL VEHICLE RENTAL"
			when "7521"
			 "AUTOMOBILE PARKING"
			when "7532"
			 "TOP, BODY, AND UPHOLSTERY REPAIR SHOPS AND PAINT SHOPS"
			when "7533"
			 "AUTOMOTIVE EXHAUST SYSTEM REPAIR SHOPS"
			when "7534"
			 "TIRE RETREADING AND REPAIR SHOPS"
			when "7536"
			 "AUTOMOTIVE GLASS REPLACEMENT SHOPS"
			when "7537"
			 "AUTOMOTIVE TRANSMISSION REPAIR SHOPS"
			when "7538"
			 "GENERAL AUTOMOTIVE REPAIR SHOPS"
			when "7539"
			 "AUTOMOTIVE REPAIR SHOPS, NOT ELSEWHERE CLASSIFIED"
			when "7542"
			 "CARWASHES"
			when "7549"
			 "AUTOMOTIVE SERVICES, EXCEPT REPAIR AND CARWASHES"
			when "7622"
			 "RADIO AND TELEVISION REPAIR SHOPS"
			when "7623"
			 "REFRIGERATION AND AIR-CONDITIONING SERVICE AND REPAIR SHOPS"
			when "7629"
			 "ELECTRICAL AND ELECTRONIC REPAIR SHOPS, NOT ELSEWHERE CLASSIFIED"
			when "7631"
			 "WATCH, CLOCK, AND JEWELRY REPAIR"
			when "7641"
			 "REUPHOLSTERY AND FURNITURE REPAIR"
			when "7692"
			 "WELDING REPAIR"
			when "7694"
			 "ARMATURE REWINDING SHOPS"
			when "7699"
			 "REPAIR SHOPS AND RELATED SERVICES, NOT ELSEWHERE CLASSIFIED"
			when "7812"
			 "MOTION PICTURE AND VIDEO TAPE PRODUCTION"
			when "7819"
			 "SERVICES ALLIED TO MOTION PICTURE PRODUCTION"
			when "7822"
			 "MOTION PICTURE AND VIDEO TAPE DISTRIBUTION"
			when "7829"
			 "SERVICES ALLIED TO MOTION PICTURE DISTRIBUTION"
			when "7832"
			 "MOTION PICTURE THEATERS, EXCEPT DRIVE-IN"
			when "7833"
			 "DRIVE-IN MOTION PICTURE THEATERS"
			when "7841"
			 "VIDEO TAPE RENTAL"
			when "7911"
			 "DANCE STUDIOS, SCHOOLS, AND HALLS"
			when "7922"
			 "THEATRICAL PRODUCERS (EXCEPT MOTION PICTURE) AND MISCELLANEOUS TH"
			when "7929"
			 "BANDS, ORCHESTRAS, ACTORS, AND OTHER ENTERTAINERS AND ENTERTAINME"
			when "7933"
			 "BOWLING CENTERS"
			when "7941"
			 "PROFESSIONAL SPORTS CLUBS AND PROMOTERS"
			when "7948"
			 "RACING, INCLUDING TRACK OPERATION"
			when "7991"
			 "PHYSICAL FITNESS FACILITIES"
			when "7992"
			 "PUBLIC GOLF COURSES"
			when "7993"
			 "COIN-OPERATED AMUSEMENT DEVICES"
			when "7996"
			 "AMUSEMENT PARKS"
			when "7997"
			 "MEMBERSHIP SPORTS AND RECREATION CLUBS"
			when "7999"
			 "AMUSEMENT AND RECREATION SERVICES, NOT ELSEWHERE CLASSIFIED"
			when "8011"
			 "OFFICES AND CLINICS OF DOCTORS OF MEDICINE"
			when "8021"
			 "OFFICES AND CLINICS OF DENTISTS"
			when "8031"
			 "OFFICES AND CLINICS OF DOCTORS OF OSTEOPATHY"
			when "8041"
			 "OFFICES AND CLINICS OF CHIROPRACTORS"
			when "8042"
			 "OFFICES AND CLINICS OF OPTOMETRISTS"
			when "8043"
			 "OFFICES AND CLINICS OF PODIATRISTS"
			when "8049"
			 "OFFICES AND CLINICS OF HEALTH PRACTITIONERS, NOT ELSEWHERE CLASSI"
			when "8051"
			 "SKILLED NURSING CARE FACILITIES"
			when "8052"
			 "INTERMEDIATE CARE FACILITIES"
			when "8059"
			 "NURSING AND PERSONAL CARE FACILITIES, NOT ELSEWHERE CLASSIFIED"
			when "8062"
			 "GENERAL MEDICAL AND SURGICAL HOSPITALS"
			when "8063"
			 "PSYCHIATRIC HOSPITALS"
			when "8069"
			 "SPECIALTY HOSPITALS, EXCEPT PSYCHIATRIC"
			when "8071"
			 "MEDICAL LABORATORIES"
			when "8072"
			 "DENTAL LABORATORIES"
			when "8082"
			 "HOME HEALTH CARE SERVICES"
			when "8092"
			 "KIDNEY DIALYSIS CENTERS"
			when "8093"
			 "SPECIALTY OUTPATIENT FACILITIES, NOT ELSEWHERE CLASSIFIED"
			when "8099"
			 "HEALTH AND ALLIED SERVICES, NOT ELSEWHERE CLASSIFIED"
			when "8111"
			 "LEGAL SERVICES"
			when "8211"
			 "ELEMENTARY AND SECONDARY SCHOOLS"
			when "8221"
			 "COLLEGES, UNIVERSITIES, AND PROFESSIONAL SCHOOLS"
			when "8222"
			 "JUNIOR COLLEGES AND TECHNICAL INSTITUTES"
			when "8231"
			 "LIBRARIES"
			when "8243"
			 "DATA PROCESSING SCHOOLS"
			when "8244"
			 "BUSINESS AND SECRETARIAL SCHOOLS"
			when "8249"
			 "VOCATIONAL SCHOOLS, NOT ELSEWHERE CLASSIFIED"
			when "8299"
			 "SCHOOLS AND EDUCATIONAL SERVICES, NOT ELSEWHERE CLASSIFIED"
			when "8322"
			 "INDIVIDUAL AND FAMILY SOCIAL SERVICES"
			when "8331"
			 "JOB TRAINING AND VOCATIONAL REHABILITATION SERVICES"
			when "8351"
			 "CHILD DAY CARE SERVICES"
			when "8361"
			 "RESIDENTIAL CARE"
			when "8399"
			 "SOCIAL SERVICES, NOT ELSEWHERE CLASSIFIED"
			when "8412"
			 "MUSEUMS AND ART GALLERIES"
			when "8422"
			 "ARBORETA AND BOTANICAL OR ZOOLOGICAL GARDENS"
			when "8611"
			 "BUSINESS ASSOCIATIONS"
			when "8621"
			 "PROFESSIONAL MEMBERSHIP ORGANIZATIONS"
			when "8631"
			 "LABOR UNIONS AND SIMILAR LABOR ORGANIZATIONS"
			when "8641"
			 "CIVIC, SOCIAL, AND FRATERNAL ASSOCIATIONS"
			when "8651"
			 "POLITICAL ORGANIZATIONS"
			when "8661"
			 "RELIGIOUS ORGANIZATIONS"
			when "8699"
			 "MEMBERSHIP ORGANIZATIONS, NOT ELSEWHERE CLASSIFIED"
			when "8711"
			 "ENGINEERING SERVICES"
			when "8712"
			 "ARCHITECTURAL SERVICES"
			when "8713"
			 "SURVEYING SERVICES"
			when "8721"
			 "ACCOUNTING, AUDITING, AND BOOKKEEPING SERVICES"
			when "8731"
			 "COMMERCIAL PHYSICAL AND BIOLOGICAL RESEARCH"
			when "8732"
			 "COMMERCIAL ECONOMIC, SOCIOLOGICAL, AND EDUCATIONAL RESEARCH"
			when "8733"
			 "NONCOMMERCIAL RESEARCH ORGANIZATIONS"
			when "8734"
			 "TESTING LABORATORIES"
			when "8741"
			 "MANAGEMENT SERVICES"
			when "8742"
			 "MANAGEMENT CONSULTING SERVICES"
			when "8743"
			 "PUBLIC RELATIONS SERVICES"
			when "8744"
			 "FACILITIES SUPPORT MANAGEMENT SERVICES"
			when "8748"
			 "BUSINESS CONSULTING SERVICES, NOT ELSEWHERE CLASSIFIED"
			when "8811"
			 "PRIVATE HOUSEHOLDS"
			when "8999"
			 "SERVICES, NOT ELSEWHERE CLASSIFIED"
			when "9111"
			 "EXECUTIVE OFFICES"
			when "9121"
			 "LEGISLATIVE BODIES"
			when "9131"
			 "EXECUTIVE AND LEGISLATIVE OFFICES COMBINED"
			when "9199"
			 "GENERAL GOVERNMENT, NOT ELSEWHERE CLASSIFIED"
			when "9211"
			 "COURTS"
			when "9221"
			 "POLICE PROTECTION"
			when "9222"
			 "LEGAL COUNSEL AND PROSECUTION"
			when "9223"
			 "CORRECTIONAL INSTITUTIONS"
			when "9224"
			 "FIRE PROTECTION"
			when "9229"
			 "PUBLIC ORDER AND SAFETY, NOT ELSEWHERE CLASSIFIED"
			when "9311"
			 "PUBLIC FINANCE, TAXATION, AND MONETARY POLICY"
			when "9411"
			 "ADMINISTRATION OF EDUCATIONAL PROGRAMS"
			when "9431"
			 "ADMINISTRATION OF PUBLIC HEALTH PROGRAMS"
			when "9441"
			 "ADMINISTRATION OF SOCIAL, HUMAN RESOURCE AND INCOME MAINTENANCE P"
			when "9451"
			 "ADMINISTRATION OF VETERANS' AFFAIRS, EXCEPT HEALTH AND INSURANCE"
			when "9511"
			 "AIR AND WATER RESOURCE AND SOLID WASTE MANAGEMENT"
			when "9512"
			 "LAND, MINERAL, WILDLIFE, AND FOREST CONSERVATION"
			when "9531"
			 "ADMINISTRATION OF HOUSING PROGRAMS"
			when "9532"
			 "ADMINISTRATION OF URBAN PLANNING AND COMMUNITY AND RURAL DEVELOPM"
			when "9611"
			 "ADMINISTRATION OF GENERAL ECONOMIC PROGRAMS"
			when "9621"
			 "REGULATION AND ADMINISTRATION OF TRANSPORTATION PROGRAMS"
			when "9631"
			 "REGULATION AND ADMINISTRATION OF COMMUNICATIONS, ELECTRIC, GAS, A"
			when "9641"
			 "REGULATION OF AGRICULTURAL MARKETING AND COMMODITIES"
			when "9651"
			 "REGULATION, LICENSING, AND INSPECTION OF MISCELLANEOUS COMMERCIAL"
			when "9661"
			 "SPACE RESEARCH AND TECHNOLOGY"
			when "9711"
			 "NATIONAL SECURITY"
			when "9721"
			 "INTERNATIONAL AFFAIRS"
			when "9999"
			 "NONCLASSIFIABLE ESTABLISHMENTS"
			end
		end

		#options for a big dropdown
		def self.four_digit_sic_options
			{
				Company.four_digit_sics("0111")=>"0111",
				Company.four_digit_sics("0112")=>"0112",
				Company.four_digit_sics("0115")=>"0115",
				Company.four_digit_sics("0116")=>"0116",
				Company.four_digit_sics("0119")=>"0119",
				Company.four_digit_sics("0131")=>"0131",
				Company.four_digit_sics("0132")=>"0132",
				Company.four_digit_sics("0133")=>"0133",
				Company.four_digit_sics("0134")=>"0134",
				Company.four_digit_sics("0139")=>"0139",
				Company.four_digit_sics("0161")=>"0161",
				Company.four_digit_sics("0171")=>"0171",
				Company.four_digit_sics("0172")=>"0172",
				Company.four_digit_sics("0173")=>"0173",
				Company.four_digit_sics("0174")=>"0174",
				Company.four_digit_sics("0175")=>"0175",
				Company.four_digit_sics("0179")=>"0179",
				Company.four_digit_sics("0181")=>"0181",
				Company.four_digit_sics("0182")=>"0182",
				Company.four_digit_sics("0191")=>"0191",
				Company.four_digit_sics("0211")=>"0211",
				Company.four_digit_sics("0212")=>"0212",
				Company.four_digit_sics("0213")=>"0213",
				Company.four_digit_sics("0214")=>"0214",
				Company.four_digit_sics("0219")=>"0219",
				Company.four_digit_sics("0241")=>"0241",
				Company.four_digit_sics("0251")=>"0251",
				Company.four_digit_sics("0252")=>"0252",
				Company.four_digit_sics("0253")=>"0253",
				Company.four_digit_sics("0254")=>"0254",
				Company.four_digit_sics("0259")=>"0259",
				Company.four_digit_sics("0271")=>"0271",
				Company.four_digit_sics("0272")=>"0272",
				Company.four_digit_sics("0273")=>"0273",
				Company.four_digit_sics("0279")=>"0279",
				Company.four_digit_sics("0291")=>"0291",
				Company.four_digit_sics("0711")=>"0711",
				Company.four_digit_sics("0721")=>"0721",
				Company.four_digit_sics("0722")=>"0722",
				Company.four_digit_sics("0723")=>"0723",
				Company.four_digit_sics("0724")=>"0724",
				Company.four_digit_sics("0741")=>"0741",
				Company.four_digit_sics("0742")=>"0742",
				Company.four_digit_sics("0751")=>"0751",
				Company.four_digit_sics("0752")=>"0752",
				Company.four_digit_sics("0761")=>"0761",
				Company.four_digit_sics("0762")=>"0762",
				Company.four_digit_sics("0781")=>"0781",
				Company.four_digit_sics("0782")=>"0782",
				Company.four_digit_sics("0783")=>"0783",
				Company.four_digit_sics("0811")=>"0811",
				Company.four_digit_sics("0831")=>"0831",
				Company.four_digit_sics("0851")=>"0851",
				Company.four_digit_sics("0912")=>"0912",
				Company.four_digit_sics("0913")=>"0913",
				Company.four_digit_sics("0919")=>"0919",
				Company.four_digit_sics("0921")=>"0921",
				Company.four_digit_sics("0971")=>"0971",
				Company.four_digit_sics("1011")=>"1011",
				Company.four_digit_sics("1021")=>"1021",
				Company.four_digit_sics("1031")=>"1031",
				Company.four_digit_sics("1041")=>"1041",
				Company.four_digit_sics("1044")=>"1044",
				Company.four_digit_sics("1061")=>"1061",
				Company.four_digit_sics("1081")=>"1081",
				Company.four_digit_sics("1094")=>"1094",
				Company.four_digit_sics("1099")=>"1099",
				Company.four_digit_sics("1221")=>"1221",
				Company.four_digit_sics("1222")=>"1222",
				Company.four_digit_sics("1231")=>"1231",
				Company.four_digit_sics("1241")=>"1241",
				Company.four_digit_sics("1311")=>"1311",
				Company.four_digit_sics("1321")=>"1321",
				Company.four_digit_sics("1381")=>"1381",
				Company.four_digit_sics("1382")=>"1382",
				Company.four_digit_sics("1389")=>"1389",
				Company.four_digit_sics("1411")=>"1411",
				Company.four_digit_sics("1422")=>"1422",
				Company.four_digit_sics("1423")=>"1423",
				Company.four_digit_sics("1429")=>"1429",
				Company.four_digit_sics("1442")=>"1442",
				Company.four_digit_sics("1446")=>"1446",
				Company.four_digit_sics("1455")=>"1455",
				Company.four_digit_sics("1459")=>"1459",
				Company.four_digit_sics("1474")=>"1474",
				Company.four_digit_sics("1475")=>"1475",
				Company.four_digit_sics("1479")=>"1479",
				Company.four_digit_sics("1481")=>"1481",
				Company.four_digit_sics("1499")=>"1499",
				Company.four_digit_sics("1521")=>"1521",
				Company.four_digit_sics("1522")=>"1522",
				Company.four_digit_sics("1531")=>"1531",
				Company.four_digit_sics("1541")=>"1541",
				Company.four_digit_sics("1542")=>"1542",
				Company.four_digit_sics("1611")=>"1611",
				Company.four_digit_sics("1622")=>"1622",
				Company.four_digit_sics("1623")=>"1623",
				Company.four_digit_sics("1629")=>"1629",
				Company.four_digit_sics("1711")=>"1711",
				Company.four_digit_sics("1721")=>"1721",
				Company.four_digit_sics("1731")=>"1731",
				Company.four_digit_sics("1741")=>"1741",
				Company.four_digit_sics("1742")=>"1742",
				Company.four_digit_sics("1743")=>"1743",
				Company.four_digit_sics("1751")=>"1751",
				Company.four_digit_sics("1752")=>"1752",
				Company.four_digit_sics("1761")=>"1761",
				Company.four_digit_sics("1771")=>"1771",
				Company.four_digit_sics("1781")=>"1781",
				Company.four_digit_sics("1791")=>"1791",
				Company.four_digit_sics("1793")=>"1793",
				Company.four_digit_sics("1794")=>"1794",
				Company.four_digit_sics("1795")=>"1795",
				Company.four_digit_sics("1796")=>"1796",
				Company.four_digit_sics("1799")=>"1799",
				Company.four_digit_sics("2011")=>"2011",
				Company.four_digit_sics("2013")=>"2013",
				Company.four_digit_sics("2015")=>"2015",
				Company.four_digit_sics("2021")=>"2021",
				Company.four_digit_sics("2022")=>"2022",
				Company.four_digit_sics("2023")=>"2023",
				Company.four_digit_sics("2024")=>"2024",
				Company.four_digit_sics("2026")=>"2026",
				Company.four_digit_sics("2032")=>"2032",
				Company.four_digit_sics("2033")=>"2033",
				Company.four_digit_sics("2034")=>"2034",
				Company.four_digit_sics("2035")=>"2035",
				Company.four_digit_sics("2037")=>"2037",
				Company.four_digit_sics("2038")=>"2038",
				Company.four_digit_sics("2041")=>"2041",
				Company.four_digit_sics("2043")=>"2043",
				Company.four_digit_sics("2044")=>"2044",
				Company.four_digit_sics("2045")=>"2045",
				Company.four_digit_sics("2046")=>"2046",
				Company.four_digit_sics("2047")=>"2047",
				Company.four_digit_sics("2048")=>"2048",
				Company.four_digit_sics("2051")=>"2051",
				Company.four_digit_sics("2052")=>"2052",
				Company.four_digit_sics("2053")=>"2053",
				Company.four_digit_sics("2061")=>"2061",
				Company.four_digit_sics("2062")=>"2062",
				Company.four_digit_sics("2063")=>"2063",
				Company.four_digit_sics("2064")=>"2064",
				Company.four_digit_sics("2066")=>"2066",
				Company.four_digit_sics("2067")=>"2067",
				Company.four_digit_sics("2068")=>"2068",
				Company.four_digit_sics("2074")=>"2074",
				Company.four_digit_sics("2075")=>"2075",
				Company.four_digit_sics("2076")=>"2076",
				Company.four_digit_sics("2077")=>"2077",
				Company.four_digit_sics("2079")=>"2079",
				Company.four_digit_sics("2082")=>"2082",
				Company.four_digit_sics("2083")=>"2083",
				Company.four_digit_sics("2084")=>"2084",
				Company.four_digit_sics("2085")=>"2085",
				Company.four_digit_sics("2086")=>"2086",
				Company.four_digit_sics("2087")=>"2087",
				Company.four_digit_sics("2091")=>"2091",
				Company.four_digit_sics("2092")=>"2092",
				Company.four_digit_sics("2095")=>"2095",
				Company.four_digit_sics("2096")=>"2096",
				Company.four_digit_sics("2097")=>"2097",
				Company.four_digit_sics("2098")=>"2098",
				Company.four_digit_sics("2099")=>"2099",
				Company.four_digit_sics("2111")=>"2111",
				Company.four_digit_sics("2121")=>"2121",
				Company.four_digit_sics("2131")=>"2131",
				Company.four_digit_sics("2141")=>"2141",
				Company.four_digit_sics("2211")=>"2211",
				Company.four_digit_sics("2221")=>"2221",
				Company.four_digit_sics("2231")=>"2231",
				Company.four_digit_sics("2241")=>"2241",
				Company.four_digit_sics("2251")=>"2251",
				Company.four_digit_sics("2252")=>"2252",
				Company.four_digit_sics("2253")=>"2253",
				Company.four_digit_sics("2254")=>"2254",
				Company.four_digit_sics("2257")=>"2257",
				Company.four_digit_sics("2258")=>"2258",
				Company.four_digit_sics("2259")=>"2259",
				Company.four_digit_sics("2261")=>"2261",
				Company.four_digit_sics("2262")=>"2262",
				Company.four_digit_sics("2269")=>"2269",
				Company.four_digit_sics("2273")=>"2273",
				Company.four_digit_sics("2281")=>"2281",
				Company.four_digit_sics("2282")=>"2282",
				Company.four_digit_sics("2282")=>"2282",
				Company.four_digit_sics("2284")=>"2284",
				Company.four_digit_sics("2295")=>"2295",
				Company.four_digit_sics("2296")=>"2296",
				Company.four_digit_sics("2297")=>"2297",
				Company.four_digit_sics("2298")=>"2298",
				Company.four_digit_sics("2299")=>"2299",
				Company.four_digit_sics("2311")=>"2311",
				Company.four_digit_sics("2321")=>"2321",
				Company.four_digit_sics("2322")=>"2322",
				Company.four_digit_sics("2323")=>"2323",
				Company.four_digit_sics("2325")=>"2325",
				Company.four_digit_sics("2326")=>"2326",
				Company.four_digit_sics("2329")=>"2329",
				Company.four_digit_sics("2331")=>"2331",
				Company.four_digit_sics("2335")=>"2335",
				Company.four_digit_sics("2337")=>"2337",
				Company.four_digit_sics("2339")=>"2339",
				Company.four_digit_sics("2341")=>"2341",
				Company.four_digit_sics("2342")=>"2342",
				Company.four_digit_sics("2353")=>"2353",
				Company.four_digit_sics("2361")=>"2361",
				Company.four_digit_sics("2369")=>"2369",
				Company.four_digit_sics("2371")=>"2371",
				Company.four_digit_sics("2381")=>"2381",
				Company.four_digit_sics("2384")=>"2384",
				Company.four_digit_sics("2385")=>"2385",
				Company.four_digit_sics("2386")=>"2386",
				Company.four_digit_sics("2387")=>"2387",
				Company.four_digit_sics("2389")=>"2389",
				Company.four_digit_sics("2391")=>"2391",
				Company.four_digit_sics("2392")=>"2392",
				Company.four_digit_sics("2393")=>"2393",
				Company.four_digit_sics("2394")=>"2394",
				Company.four_digit_sics("2395")=>"2395",
				Company.four_digit_sics("2396")=>"2396",
				Company.four_digit_sics("2397")=>"2397",
				Company.four_digit_sics("2399")=>"2399",
				Company.four_digit_sics("2411")=>"2411",
				Company.four_digit_sics("2421")=>"2421",
				Company.four_digit_sics("2426")=>"2426",
				Company.four_digit_sics("2429")=>"2429",
				Company.four_digit_sics("2431")=>"2431",
				Company.four_digit_sics("2434")=>"2434",
				Company.four_digit_sics("2435")=>"2435",
				Company.four_digit_sics("2436")=>"2436",
				Company.four_digit_sics("2439")=>"2439",
				Company.four_digit_sics("2441")=>"2441",
				Company.four_digit_sics("2448")=>"2448",
				Company.four_digit_sics("2449")=>"2449",
				Company.four_digit_sics("2451")=>"2451",
				Company.four_digit_sics("2452")=>"2452",
				Company.four_digit_sics("2491")=>"2491",
				Company.four_digit_sics("2493")=>"2493",
				Company.four_digit_sics("2499")=>"2499",
				Company.four_digit_sics("2511")=>"2511",
				Company.four_digit_sics("2512")=>"2512",
				Company.four_digit_sics("2514")=>"2514",
				Company.four_digit_sics("2515")=>"2515",
				Company.four_digit_sics("2517")=>"2517",
				Company.four_digit_sics("2519")=>"2519",
				Company.four_digit_sics("2521")=>"2521",
				Company.four_digit_sics("2522")=>"2522",
				Company.four_digit_sics("2531")=>"2531",
				Company.four_digit_sics("2541")=>"2541",
				Company.four_digit_sics("2542")=>"2542",
				Company.four_digit_sics("2591")=>"2591",
				Company.four_digit_sics("2599")=>"2599",
				Company.four_digit_sics("2611")=>"2611",
				Company.four_digit_sics("2621")=>"2621",
				Company.four_digit_sics("2631")=>"2631",
				Company.four_digit_sics("2652")=>"2652",
				Company.four_digit_sics("2653")=>"2653",
				Company.four_digit_sics("2655")=>"2655",
				Company.four_digit_sics("2656")=>"2656",
				Company.four_digit_sics("2657")=>"2657",
				Company.four_digit_sics("2671")=>"2671",
				Company.four_digit_sics("2672")=>"2672",
				Company.four_digit_sics("2673")=>"2673",
				Company.four_digit_sics("2674")=>"2674",
				Company.four_digit_sics("2675")=>"2675",
				Company.four_digit_sics("2676")=>"2676",
				Company.four_digit_sics("2677")=>"2677",
				Company.four_digit_sics("2678")=>"2678",
				Company.four_digit_sics("2679")=>"2679",
				Company.four_digit_sics("2711")=>"2711",
				Company.four_digit_sics("2721")=>"2721",
				Company.four_digit_sics("2731")=>"2731",
				Company.four_digit_sics("2732")=>"2732",
				Company.four_digit_sics("2741")=>"2741",
				Company.four_digit_sics("2752")=>"2752",
				Company.four_digit_sics("2754")=>"2754",
				Company.four_digit_sics("2759")=>"2759",
				Company.four_digit_sics("2761")=>"2761",
				Company.four_digit_sics("2771")=>"2771",
				Company.four_digit_sics("2782")=>"2782",
				Company.four_digit_sics("2789")=>"2789",
				Company.four_digit_sics("2791")=>"2791",
				Company.four_digit_sics("2796")=>"2796",
				Company.four_digit_sics("2812")=>"2812",
				Company.four_digit_sics("2813")=>"2813",
				Company.four_digit_sics("2816")=>"2816",
				Company.four_digit_sics("2819")=>"2819",
				Company.four_digit_sics("2821")=>"2821",
				Company.four_digit_sics("2822")=>"2822",
				Company.four_digit_sics("2823")=>"2823",
				Company.four_digit_sics("2824")=>"2824",
				Company.four_digit_sics("2833")=>"2833",
				Company.four_digit_sics("2834")=>"2834",
				Company.four_digit_sics("2835")=>"2835",
				Company.four_digit_sics("2836")=>"2836",
				Company.four_digit_sics("2841")=>"2841",
				Company.four_digit_sics("2842")=>"2842",
				Company.four_digit_sics("2843")=>"2843",
				Company.four_digit_sics("2844")=>"2844",
				Company.four_digit_sics("2851")=>"2851",
				Company.four_digit_sics("2861")=>"2861",
				Company.four_digit_sics("2865")=>"2865",
				Company.four_digit_sics("2869")=>"2869",
				Company.four_digit_sics("2873")=>"2873",
				Company.four_digit_sics("2874")=>"2874",
				Company.four_digit_sics("2875")=>"2875",
				Company.four_digit_sics("2879")=>"2879",
				Company.four_digit_sics("2891")=>"2891",
				Company.four_digit_sics("2892")=>"2892",
				Company.four_digit_sics("2893")=>"2893",
				Company.four_digit_sics("2895")=>"2895",
				Company.four_digit_sics("2899")=>"2899",
				Company.four_digit_sics("2911")=>"2911",
				Company.four_digit_sics("2951")=>"2951",
				Company.four_digit_sics("2952")=>"2952",
				Company.four_digit_sics("2992")=>"2992",
				Company.four_digit_sics("2999")=>"2999",
				Company.four_digit_sics("3011")=>"3011",
				Company.four_digit_sics("3021")=>"3021",
				Company.four_digit_sics("3052")=>"3052",
				Company.four_digit_sics("3053")=>"3053",
				Company.four_digit_sics("3061")=>"3061",
				Company.four_digit_sics("3069")=>"3069",
				Company.four_digit_sics("3081")=>"3081",
				Company.four_digit_sics("3082")=>"3082",
				Company.four_digit_sics("3083")=>"3083",
				Company.four_digit_sics("3084")=>"3084",
				Company.four_digit_sics("3085")=>"3085",
				Company.four_digit_sics("3086")=>"3086",
				Company.four_digit_sics("3087")=>"3087",
				Company.four_digit_sics("3088")=>"3088",
				Company.four_digit_sics("3089")=>"3089",
				Company.four_digit_sics("3111")=>"3111",
				Company.four_digit_sics("3131")=>"3131",
				Company.four_digit_sics("3142")=>"3142",
				Company.four_digit_sics("3143")=>"3143",
				Company.four_digit_sics("3144")=>"3144",
				Company.four_digit_sics("3149")=>"3149",
				Company.four_digit_sics("3151")=>"3151",
				Company.four_digit_sics("3161")=>"3161",
				Company.four_digit_sics("3171")=>"3171",
				Company.four_digit_sics("3172")=>"3172",
				Company.four_digit_sics("3199")=>"3199",
				Company.four_digit_sics("3211")=>"3211",
				Company.four_digit_sics("3221")=>"3221",
				Company.four_digit_sics("3229")=>"3229",
				Company.four_digit_sics("3231")=>"3231",
				Company.four_digit_sics("3241")=>"3241",
				Company.four_digit_sics("3251")=>"3251",
				Company.four_digit_sics("3253")=>"3253",
				Company.four_digit_sics("3255")=>"3255",
				Company.four_digit_sics("3259")=>"3259",
				Company.four_digit_sics("3261")=>"3261",
				Company.four_digit_sics("3262")=>"3262",
				Company.four_digit_sics("3263")=>"3263",
				Company.four_digit_sics("3264")=>"3264",
				Company.four_digit_sics("3269")=>"3269",
				Company.four_digit_sics("3271")=>"3271",
				Company.four_digit_sics("3272")=>"3272",
				Company.four_digit_sics("3273")=>"3273",
				Company.four_digit_sics("3274")=>"3274",
				Company.four_digit_sics("3275")=>"3275",
				Company.four_digit_sics("3281")=>"3281",
				Company.four_digit_sics("3291")=>"3291",
				Company.four_digit_sics("3292")=>"3292",
				Company.four_digit_sics("3295")=>"3295",
				Company.four_digit_sics("3296")=>"3296",
				Company.four_digit_sics("3297")=>"3297",
				Company.four_digit_sics("3299")=>"3299",
				Company.four_digit_sics("3312")=>"3312",
				Company.four_digit_sics("3313")=>"3313",
				Company.four_digit_sics("3315")=>"3315",
				Company.four_digit_sics("3316")=>"3316",
				Company.four_digit_sics("3317")=>"3317",
				Company.four_digit_sics("3321")=>"3321",
				Company.four_digit_sics("3322")=>"3322",
				Company.four_digit_sics("3324")=>"3324",
				Company.four_digit_sics("3325")=>"3325",
				Company.four_digit_sics("3331")=>"3331",
				Company.four_digit_sics("3334")=>"3334",
				Company.four_digit_sics("3339")=>"3339",
				Company.four_digit_sics("3341")=>"3341",
				Company.four_digit_sics("3351")=>"3351",
				Company.four_digit_sics("3353")=>"3353",
				Company.four_digit_sics("3354")=>"3354",
				Company.four_digit_sics("3355")=>"3355",
				Company.four_digit_sics("3356")=>"3356",
				Company.four_digit_sics("3357")=>"3357",
				Company.four_digit_sics("3363")=>"3363",
				Company.four_digit_sics("3364")=>"3364",
				Company.four_digit_sics("3365")=>"3365",
				Company.four_digit_sics("3366")=>"3366",
				Company.four_digit_sics("3369")=>"3369",
				Company.four_digit_sics("3398")=>"3398",
				Company.four_digit_sics("3399")=>"3399",
				Company.four_digit_sics("3411")=>"3411",
				Company.four_digit_sics("3412")=>"3412",
				Company.four_digit_sics("3421")=>"3421",
				Company.four_digit_sics("3423")=>"3423",
				Company.four_digit_sics("3425")=>"3425",
				Company.four_digit_sics("3429")=>"3429",
				Company.four_digit_sics("3431")=>"3431",
				Company.four_digit_sics("3432")=>"3432",
				Company.four_digit_sics("3433")=>"3433",
				Company.four_digit_sics("3441")=>"3441",
				Company.four_digit_sics("3442")=>"3442",
				Company.four_digit_sics("3443")=>"3443",
				Company.four_digit_sics("3444")=>"3444",
				Company.four_digit_sics("3446")=>"3446",
				Company.four_digit_sics("3448")=>"3448",
				Company.four_digit_sics("3449")=>"3449",
				Company.four_digit_sics("3451")=>"3451",
				Company.four_digit_sics("3452")=>"3452",
				Company.four_digit_sics("3462")=>"3462",
				Company.four_digit_sics("3463")=>"3463",
				Company.four_digit_sics("3465")=>"3465",
				Company.four_digit_sics("3466")=>"3466",
				Company.four_digit_sics("3469")=>"3469",
				Company.four_digit_sics("3471")=>"3471",
				Company.four_digit_sics("3479")=>"3479",
				Company.four_digit_sics("3482")=>"3482",
				Company.four_digit_sics("3483")=>"3483",
				Company.four_digit_sics("3484")=>"3484",
				Company.four_digit_sics("3489")=>"3489",
				Company.four_digit_sics("3491")=>"3491",
				Company.four_digit_sics("3492")=>"3492",
				Company.four_digit_sics("3493")=>"3493",
				Company.four_digit_sics("3494")=>"3494",
				Company.four_digit_sics("3495")=>"3495",
				Company.four_digit_sics("3496")=>"3496",
				Company.four_digit_sics("3497")=>"3497",
				Company.four_digit_sics("3498")=>"3498",
				Company.four_digit_sics("3499")=>"3499",
				Company.four_digit_sics("3511")=>"3511",
				Company.four_digit_sics("3519")=>"3519",
				Company.four_digit_sics("3523")=>"3523",
				Company.four_digit_sics("3524")=>"3524",
				Company.four_digit_sics("3524")=>"3524",
				Company.four_digit_sics("3531")=>"3531",
				Company.four_digit_sics("3532")=>"3532",
				Company.four_digit_sics("3533")=>"3533",
				Company.four_digit_sics("3534")=>"3534",
				Company.four_digit_sics("3535")=>"3535",
				Company.four_digit_sics("3536")=>"3536",
				Company.four_digit_sics("3537")=>"3537",
				Company.four_digit_sics("3541")=>"3541",
				Company.four_digit_sics("3542")=>"3542",
				Company.four_digit_sics("3543")=>"3543",
				Company.four_digit_sics("3544")=>"3544",
				Company.four_digit_sics("3545")=>"3545",
				Company.four_digit_sics("3546")=>"3546",
				Company.four_digit_sics("3547")=>"3547",
				Company.four_digit_sics("3548")=>"3548",
				Company.four_digit_sics("3549")=>"3549",
				Company.four_digit_sics("3552")=>"3552",
				Company.four_digit_sics("3553")=>"3553",
				Company.four_digit_sics("3554")=>"3554",
				Company.four_digit_sics("3555")=>"3555",
				Company.four_digit_sics("3556")=>"3556",
				Company.four_digit_sics("3559")=>"3559",
				Company.four_digit_sics("3561")=>"3561",
				Company.four_digit_sics("3562")=>"3562",
				Company.four_digit_sics("3563")=>"3563",
				Company.four_digit_sics("3564")=>"3564",
				Company.four_digit_sics("3565")=>"3565",
				Company.four_digit_sics("3566")=>"3566",
				Company.four_digit_sics("3567")=>"3567",
				Company.four_digit_sics("3568")=>"3568",
				Company.four_digit_sics("3569")=>"3569",
				Company.four_digit_sics("3571")=>"3571",
				Company.four_digit_sics("3572")=>"3572",
				Company.four_digit_sics("3575")=>"3575",
				Company.four_digit_sics("3577")=>"3577",
				Company.four_digit_sics("3578")=>"3578",
				Company.four_digit_sics("3579")=>"3579",
				Company.four_digit_sics("3581")=>"3581",
				Company.four_digit_sics("3582")=>"3582",
				Company.four_digit_sics("3585")=>"3585",
				Company.four_digit_sics("3586")=>"3586",
				Company.four_digit_sics("3589")=>"3589",
				Company.four_digit_sics("3592")=>"3592",
				Company.four_digit_sics("3593")=>"3593",
				Company.four_digit_sics("3594")=>"3594",
				Company.four_digit_sics("3596")=>"3596",
				Company.four_digit_sics("3599")=>"3599",
				Company.four_digit_sics("3612")=>"3612",
				Company.four_digit_sics("3613")=>"3613",
				Company.four_digit_sics("3621")=>"3621",
				Company.four_digit_sics("3624")=>"3624",
				Company.four_digit_sics("3625")=>"3625",
				Company.four_digit_sics("3629")=>"3629",
				Company.four_digit_sics("3631")=>"3631",
				Company.four_digit_sics("3632")=>"3632",
				Company.four_digit_sics("3633")=>"3633",
				Company.four_digit_sics("3634")=>"3634",
				Company.four_digit_sics("3635")=>"3635",
				Company.four_digit_sics("3639")=>"3639",
				Company.four_digit_sics("3641")=>"3641",
				Company.four_digit_sics("3643")=>"3643",
				Company.four_digit_sics("3644")=>"3644",
				Company.four_digit_sics("3645")=>"3645",
				Company.four_digit_sics("3646")=>"3646",
				Company.four_digit_sics("3647")=>"3647",
				Company.four_digit_sics("3648")=>"3648",
				Company.four_digit_sics("3651")=>"3651",
				Company.four_digit_sics("3652")=>"3652",
				Company.four_digit_sics("3661")=>"3661",
				Company.four_digit_sics("3663")=>"3663",
				Company.four_digit_sics("3669")=>"3669",
				Company.four_digit_sics("3671")=>"3671",
				Company.four_digit_sics("3672")=>"3672",
				Company.four_digit_sics("3674")=>"3674",
				Company.four_digit_sics("3675")=>"3675",
				Company.four_digit_sics("3676")=>"3676",
				Company.four_digit_sics("3677")=>"3677",
				Company.four_digit_sics("3678")=>"3678",
				Company.four_digit_sics("3679")=>"3679",
				Company.four_digit_sics("3691")=>"3691",
				Company.four_digit_sics("3692")=>"3692",
				Company.four_digit_sics("3694")=>"3694",
				Company.four_digit_sics("3695")=>"3695",
				Company.four_digit_sics("3699")=>"3699",
				Company.four_digit_sics("3711")=>"3711",
				Company.four_digit_sics("3713")=>"3713",
				Company.four_digit_sics("3714")=>"3714",
				Company.four_digit_sics("3715")=>"3715",
				Company.four_digit_sics("3716")=>"3716",
				Company.four_digit_sics("3721")=>"3721",
				Company.four_digit_sics("3724")=>"3724",
				Company.four_digit_sics("3728")=>"3728",
				Company.four_digit_sics("3731")=>"3731",
				Company.four_digit_sics("3732")=>"3732",
				Company.four_digit_sics("3743")=>"3743",
				Company.four_digit_sics("3751")=>"3751",
				Company.four_digit_sics("3761")=>"3761",
				Company.four_digit_sics("3764")=>"3764",
				Company.four_digit_sics("3769")=>"3769",
				Company.four_digit_sics("3792")=>"3792",
				Company.four_digit_sics("3795")=>"3795",
				Company.four_digit_sics("3799")=>"3799",
				Company.four_digit_sics("3812")=>"3812",
				Company.four_digit_sics("3821")=>"3821",
				Company.four_digit_sics("3822")=>"3822",
				Company.four_digit_sics("3823")=>"3823",
				Company.four_digit_sics("3824")=>"3824",
				Company.four_digit_sics("3825")=>"3825",
				Company.four_digit_sics("3826")=>"3826",
				Company.four_digit_sics("3827")=>"3827",
				Company.four_digit_sics("3829")=>"3829",
				Company.four_digit_sics("3841")=>"3841",
				Company.four_digit_sics("3842")=>"3842",
				Company.four_digit_sics("3843")=>"3843",
				Company.four_digit_sics("3844")=>"3844",
				Company.four_digit_sics("3845")=>"3845",
				Company.four_digit_sics("3851")=>"3851",
				Company.four_digit_sics("3861")=>"3861",
				Company.four_digit_sics("3873")=>"3873",
				Company.four_digit_sics("3911")=>"3911",
				Company.four_digit_sics("3914")=>"3914",
				Company.four_digit_sics("3915")=>"3915",
				Company.four_digit_sics("3931")=>"3931",
				Company.four_digit_sics("3942")=>"3942",
				Company.four_digit_sics("3944")=>"3944",
				Company.four_digit_sics("3949")=>"3949",
				Company.four_digit_sics("3951")=>"3951",
				Company.four_digit_sics("3952")=>"3952",
				Company.four_digit_sics("3953")=>"3953",
				Company.four_digit_sics("3955")=>"3955",
				Company.four_digit_sics("3961")=>"3961",
				Company.four_digit_sics("3965")=>"3965",
				Company.four_digit_sics("3991")=>"3991",
				Company.four_digit_sics("3993")=>"3993",
				Company.four_digit_sics("3995")=>"3995",
				Company.four_digit_sics("3996")=>"3996",
				Company.four_digit_sics("3999")=>"3999",
				Company.four_digit_sics("4011")=>"4011",
				Company.four_digit_sics("4013")=>"4013",
				Company.four_digit_sics("4111")=>"4111",
				Company.four_digit_sics("4119")=>"4119",
				Company.four_digit_sics("4121")=>"4121",
				Company.four_digit_sics("4131")=>"4131",
				Company.four_digit_sics("4141")=>"4141",
				Company.four_digit_sics("4142")=>"4142",
				Company.four_digit_sics("4151")=>"4151",
				Company.four_digit_sics("4173")=>"4173",
				Company.four_digit_sics("4212")=>"4212",
				Company.four_digit_sics("4213")=>"4213",
				Company.four_digit_sics("4214")=>"4214",
				Company.four_digit_sics("4215")=>"4215",
				Company.four_digit_sics("4221")=>"4221",
				Company.four_digit_sics("4222")=>"4222",
				Company.four_digit_sics("4225")=>"4225",
				Company.four_digit_sics("4226")=>"4226",
				Company.four_digit_sics("4231")=>"4231",
				Company.four_digit_sics("4311")=>"4311",
				Company.four_digit_sics("4412")=>"4412",
				Company.four_digit_sics("4424")=>"4424",
				Company.four_digit_sics("4432")=>"4432",
				Company.four_digit_sics("4449")=>"4449",
				Company.four_digit_sics("4481")=>"4481",
				Company.four_digit_sics("4482")=>"4482",
				Company.four_digit_sics("4489")=>"4489",
				Company.four_digit_sics("4491")=>"4491",
				Company.four_digit_sics("4492")=>"4492",
				Company.four_digit_sics("4493")=>"4493",
				Company.four_digit_sics("4499")=>"4499",
				Company.four_digit_sics("4512")=>"4512",
				Company.four_digit_sics("4513")=>"4513",
				Company.four_digit_sics("4522")=>"4522",
				Company.four_digit_sics("4581")=>"4581",
				Company.four_digit_sics("4612")=>"4612",
				Company.four_digit_sics("4613")=>"4613",
				Company.four_digit_sics("4619")=>"4619",
				Company.four_digit_sics("4724")=>"4724",
				Company.four_digit_sics("4725")=>"4725",
				Company.four_digit_sics("4729")=>"4729",
				Company.four_digit_sics("4731")=>"4731",
				Company.four_digit_sics("4741")=>"4741",
				Company.four_digit_sics("4783")=>"4783",
				Company.four_digit_sics("4785")=>"4785",
				Company.four_digit_sics("4785")=>"4785",
				Company.four_digit_sics("4789")=>"4789",
				Company.four_digit_sics("4812")=>"4812",
				Company.four_digit_sics("4813")=>"4813",
				Company.four_digit_sics("4822")=>"4822",
				Company.four_digit_sics("4832")=>"4832",
				Company.four_digit_sics("4833")=>"4833",
				Company.four_digit_sics("4841")=>"4841",
				Company.four_digit_sics("4899")=>"4899",
				Company.four_digit_sics("4911")=>"4911",
				Company.four_digit_sics("4922")=>"4922",
				Company.four_digit_sics("4923")=>"4923",
				Company.four_digit_sics("4924")=>"4924",
				Company.four_digit_sics("4925")=>"4925",
				Company.four_digit_sics("4931")=>"4931",
				Company.four_digit_sics("4932")=>"4932",
				Company.four_digit_sics("4939")=>"4939",
				Company.four_digit_sics("4941")=>"4941",
				Company.four_digit_sics("4952")=>"4952",
				Company.four_digit_sics("4953")=>"4953",
				Company.four_digit_sics("4959")=>"4959",
				Company.four_digit_sics("4961")=>"4961",
				Company.four_digit_sics("4971")=>"4971",
				Company.four_digit_sics("5012")=>"5012",
				Company.four_digit_sics("5013")=>"5013",
				Company.four_digit_sics("5014")=>"5014",
				Company.four_digit_sics("5015")=>"5015",
				Company.four_digit_sics("5021")=>"5021",
				Company.four_digit_sics("5023")=>"5023",
				Company.four_digit_sics("5031")=>"5031",
				Company.four_digit_sics("5032")=>"5032",
				Company.four_digit_sics("5033")=>"5033",
				Company.four_digit_sics("5039")=>"5039",
				Company.four_digit_sics("5043")=>"5043",
				Company.four_digit_sics("5044")=>"5044",
				Company.four_digit_sics("5045")=>"5045",
				Company.four_digit_sics("5046")=>"5046",
				Company.four_digit_sics("5047")=>"5047",
				Company.four_digit_sics("5048")=>"5048",
				Company.four_digit_sics("5049")=>"5049",
				Company.four_digit_sics("5051")=>"5051",
				Company.four_digit_sics("5052")=>"5052",
				Company.four_digit_sics("5063")=>"5063",
				Company.four_digit_sics("5064")=>"5064",
				Company.four_digit_sics("5065")=>"5065",
				Company.four_digit_sics("5072")=>"5072",
				Company.four_digit_sics("5074")=>"5074",
				Company.four_digit_sics("5075")=>"5075",
				Company.four_digit_sics("5078")=>"5078",
				Company.four_digit_sics("5082")=>"5082",
				Company.four_digit_sics("5083")=>"5083",
				Company.four_digit_sics("5084")=>"5084",
				Company.four_digit_sics("5085")=>"5085",
				Company.four_digit_sics("5087")=>"5087",
				Company.four_digit_sics("5088")=>"5088",
				Company.four_digit_sics("5091")=>"5091",
				Company.four_digit_sics("5092")=>"5092",
				Company.four_digit_sics("5093")=>"5093",
				Company.four_digit_sics("5094")=>"5094",
				Company.four_digit_sics("5099")=>"5099",
				Company.four_digit_sics("5111")=>"5111",
				Company.four_digit_sics("5112")=>"5112",
				Company.four_digit_sics("5113")=>"5113",
				Company.four_digit_sics("5122")=>"5122",
				Company.four_digit_sics("5131")=>"5131",
				Company.four_digit_sics("5136")=>"5136",
				Company.four_digit_sics("5137")=>"5137",
				Company.four_digit_sics("5139")=>"5139",
				Company.four_digit_sics("5141")=>"5141",
				Company.four_digit_sics("5142")=>"5142",
				Company.four_digit_sics("5143")=>"5143",
				Company.four_digit_sics("5144")=>"5144",
				Company.four_digit_sics("5145")=>"5145",
				Company.four_digit_sics("5146")=>"5146",
				Company.four_digit_sics("5147")=>"5147",
				Company.four_digit_sics("5148")=>"5148",
				Company.four_digit_sics("5149")=>"5149",
				Company.four_digit_sics("5153")=>"5153",
				Company.four_digit_sics("5154")=>"5154",
				Company.four_digit_sics("5159")=>"5159",
				Company.four_digit_sics("5162")=>"5162",
				Company.four_digit_sics("5169")=>"5169",
				Company.four_digit_sics("5171")=>"5171",
				Company.four_digit_sics("5172")=>"5172",
				Company.four_digit_sics("5181")=>"5181",
				Company.four_digit_sics("5182")=>"5182",
				Company.four_digit_sics("5191")=>"5191",
				Company.four_digit_sics("5192")=>"5192",
				Company.four_digit_sics("5193")=>"5193",
				Company.four_digit_sics("5194")=>"5194",
				Company.four_digit_sics("5198")=>"5198",
				Company.four_digit_sics("5199")=>"5199",
				Company.four_digit_sics("5211")=>"5211",
				Company.four_digit_sics("5231")=>"5231",
				Company.four_digit_sics("5251")=>"5251",
				Company.four_digit_sics("5261")=>"5261",
				Company.four_digit_sics("5271")=>"5271",
				Company.four_digit_sics("5311")=>"5311",
				Company.four_digit_sics("5331")=>"5331",
				Company.four_digit_sics("5399")=>"5399",
				Company.four_digit_sics("5411")=>"5411",
				Company.four_digit_sics("5421")=>"5421",
				Company.four_digit_sics("5431")=>"5431",
				Company.four_digit_sics("5441")=>"5441",
				Company.four_digit_sics("5451")=>"5451",
				Company.four_digit_sics("5461")=>"5461",
				Company.four_digit_sics("5499")=>"5499",
				Company.four_digit_sics("5511")=>"5511",
				Company.four_digit_sics("5521")=>"5521",
				Company.four_digit_sics("5531")=>"5531",
				Company.four_digit_sics("5541")=>"5541",
				Company.four_digit_sics("5551")=>"5551",
				Company.four_digit_sics("5561")=>"5561",
				Company.four_digit_sics("5571")=>"5571",
				Company.four_digit_sics("5599")=>"5599",
				Company.four_digit_sics("5611")=>"5611",
				Company.four_digit_sics("5621")=>"5621",
				Company.four_digit_sics("5632")=>"5632",
				Company.four_digit_sics("5641")=>"5641",
				Company.four_digit_sics("5651")=>"5651",
				Company.four_digit_sics("5661")=>"5661",
				Company.four_digit_sics("5699")=>"5699",
				Company.four_digit_sics("5712")=>"5712",
				Company.four_digit_sics("5713")=>"5713",
				Company.four_digit_sics("5714")=>"5714",
				Company.four_digit_sics("5719")=>"5719",
				Company.four_digit_sics("5722")=>"5722",
				Company.four_digit_sics("5731")=>"5731",
				Company.four_digit_sics("5734")=>"5734",
				Company.four_digit_sics("5735")=>"5735",
				Company.four_digit_sics("5736")=>"5736",
				Company.four_digit_sics("5812")=>"5812",
				Company.four_digit_sics("5813")=>"5813",
				Company.four_digit_sics("5912")=>"5912",
				Company.four_digit_sics("5921")=>"5921",
				Company.four_digit_sics("5932")=>"5932",
				Company.four_digit_sics("5941")=>"5941",
				Company.four_digit_sics("5942")=>"5942",
				Company.four_digit_sics("5943")=>"5943",
				Company.four_digit_sics("5944")=>"5944",
				Company.four_digit_sics("5945")=>"5945",
				Company.four_digit_sics("5946")=>"5946",
				Company.four_digit_sics("5947")=>"5947",
				Company.four_digit_sics("5948")=>"5948",
				Company.four_digit_sics("5949")=>"5949",
				Company.four_digit_sics("5961")=>"5961",
				Company.four_digit_sics("5962")=>"5962",
				Company.four_digit_sics("5963")=>"5963",
				Company.four_digit_sics("5983")=>"5983",
				Company.four_digit_sics("5984")=>"5984",
				Company.four_digit_sics("5989")=>"5989",
				Company.four_digit_sics("5992")=>"5992",
				Company.four_digit_sics("5993")=>"5993",
				Company.four_digit_sics("5994")=>"5994",
				Company.four_digit_sics("5995")=>"5995",
				Company.four_digit_sics("5999")=>"5999",
				Company.four_digit_sics("6011")=>"6011",
				Company.four_digit_sics("6019")=>"6019",
				Company.four_digit_sics("6021")=>"6021",
				Company.four_digit_sics("6022")=>"6022",
				Company.four_digit_sics("6029")=>"6029",
				Company.four_digit_sics("6035")=>"6035",
				Company.four_digit_sics("6036")=>"6036",
				Company.four_digit_sics("6061")=>"6061",
				Company.four_digit_sics("6062")=>"6062",
				Company.four_digit_sics("6081")=>"6081",
				Company.four_digit_sics("6082")=>"6082",
				Company.four_digit_sics("6091")=>"6091",
				Company.four_digit_sics("6099")=>"6099",
				Company.four_digit_sics("6111")=>"6111",
				Company.four_digit_sics("6141")=>"6141",
				Company.four_digit_sics("6153")=>"6153",
				Company.four_digit_sics("6159")=>"6159",
				Company.four_digit_sics("6162")=>"6162",
				Company.four_digit_sics("6163")=>"6163",
				Company.four_digit_sics("6211")=>"6211",
				Company.four_digit_sics("6221")=>"6221",
				Company.four_digit_sics("6231")=>"6231",
				Company.four_digit_sics("6282")=>"6282",
				Company.four_digit_sics("6289")=>"6289",
				Company.four_digit_sics("6311")=>"6311",
				Company.four_digit_sics("6321")=>"6321",
				Company.four_digit_sics("6324")=>"6324",
				Company.four_digit_sics("6331")=>"6331",
				Company.four_digit_sics("6351")=>"6351",
				Company.four_digit_sics("6361")=>"6361",
				Company.four_digit_sics("6371")=>"6371",
				Company.four_digit_sics("6399")=>"6399",
				Company.four_digit_sics("6411")=>"6411",
				Company.four_digit_sics("6512")=>"6512",
				Company.four_digit_sics("6513")=>"6513",
				Company.four_digit_sics("6514")=>"6514",
				Company.four_digit_sics("6515")=>"6515",
				Company.four_digit_sics("6517")=>"6517",
				Company.four_digit_sics("6519")=>"6519",
				Company.four_digit_sics("6531")=>"6531",
				Company.four_digit_sics("6541")=>"6541",
				Company.four_digit_sics("6552")=>"6552",
				Company.four_digit_sics("6553")=>"6553",
				Company.four_digit_sics("6712")=>"6712",
				Company.four_digit_sics("6719")=>"6719",
				Company.four_digit_sics("6722")=>"6722",
				Company.four_digit_sics("6726")=>"6726",
				Company.four_digit_sics("6732")=>"6732",
				Company.four_digit_sics("6733")=>"6733",
				Company.four_digit_sics("6792")=>"6792",
				Company.four_digit_sics("6794")=>"6794",
				Company.four_digit_sics("6798")=>"6798",
				Company.four_digit_sics("6799")=>"6799",
				Company.four_digit_sics("7011")=>"7011",
				Company.four_digit_sics("7021")=>"7021",
				Company.four_digit_sics("7032")=>"7032",
				Company.four_digit_sics("7033")=>"7033",
				Company.four_digit_sics("7041")=>"7041",
				Company.four_digit_sics("7211")=>"7211",
				Company.four_digit_sics("7212")=>"7212",
				Company.four_digit_sics("7213")=>"7213",
				Company.four_digit_sics("7215")=>"7215",
				Company.four_digit_sics("7216")=>"7216",
				Company.four_digit_sics("7217")=>"7217",
				Company.four_digit_sics("7218")=>"7218",
				Company.four_digit_sics("7219")=>"7219",
				Company.four_digit_sics("7221")=>"7221",
				Company.four_digit_sics("7231")=>"7231",
				Company.four_digit_sics("7241")=>"7241",
				Company.four_digit_sics("7251")=>"7251",
				Company.four_digit_sics("7261")=>"7261",
				Company.four_digit_sics("7291")=>"7291",
				Company.four_digit_sics("7299")=>"7299",
				Company.four_digit_sics("7311")=>"7311",
				Company.four_digit_sics("7312")=>"7312",
				Company.four_digit_sics("7313")=>"7313",
				Company.four_digit_sics("7319")=>"7319",
				Company.four_digit_sics("7322")=>"7322",
				Company.four_digit_sics("7323")=>"7323",
				Company.four_digit_sics("7331")=>"7331",
				Company.four_digit_sics("7334")=>"7334",
				Company.four_digit_sics("7335")=>"7335",
				Company.four_digit_sics("7336")=>"7336",
				Company.four_digit_sics("7338")=>"7338",
				Company.four_digit_sics("7342")=>"7342",
				Company.four_digit_sics("7349")=>"7349",
				Company.four_digit_sics("7352")=>"7352",
				Company.four_digit_sics("7353")=>"7353",
				Company.four_digit_sics("7359")=>"7359",
				Company.four_digit_sics("7361")=>"7361",
				Company.four_digit_sics("7363")=>"7363",
				Company.four_digit_sics("7371")=>"7371",
				Company.four_digit_sics("7372")=>"7372",
				Company.four_digit_sics("7373")=>"7373",
				Company.four_digit_sics("7374")=>"7374",
				Company.four_digit_sics("7375")=>"7375",
				Company.four_digit_sics("7376")=>"7376",
				Company.four_digit_sics("7377")=>"7377",
				Company.four_digit_sics("7378")=>"7378",
				Company.four_digit_sics("7379")=>"7379",
				Company.four_digit_sics("7381")=>"7381",
				Company.four_digit_sics("7382")=>"7382",
				Company.four_digit_sics("7383")=>"7383",
				Company.four_digit_sics("7384")=>"7384",
				Company.four_digit_sics("7389")=>"7389",
				Company.four_digit_sics("7513")=>"7513",
				Company.four_digit_sics("7514")=>"7514",
				Company.four_digit_sics("7515")=>"7515",
				Company.four_digit_sics("7519")=>"7519",
				Company.four_digit_sics("7521")=>"7521",
				Company.four_digit_sics("7532")=>"7532",
				Company.four_digit_sics("7533")=>"7533",
				Company.four_digit_sics("7534")=>"7534",
				Company.four_digit_sics("7536")=>"7536",
				Company.four_digit_sics("7537")=>"7537",
				Company.four_digit_sics("7538")=>"7538",
				Company.four_digit_sics("7539")=>"7539",
				Company.four_digit_sics("7542")=>"7542",
				Company.four_digit_sics("7549")=>"7549",
				Company.four_digit_sics("7622")=>"7622",
				Company.four_digit_sics("7623")=>"7623",
				Company.four_digit_sics("7629")=>"7629",
				Company.four_digit_sics("7631")=>"7631",
				Company.four_digit_sics("7641")=>"7641",
				Company.four_digit_sics("7692")=>"7692",
				Company.four_digit_sics("7694")=>"7694",
				Company.four_digit_sics("7699")=>"7699",
				Company.four_digit_sics("7812")=>"7812",
				Company.four_digit_sics("7819")=>"7819",
				Company.four_digit_sics("7822")=>"7822",
				Company.four_digit_sics("7829")=>"7829",
				Company.four_digit_sics("7832")=>"7832",
				Company.four_digit_sics("7833")=>"7833",
				Company.four_digit_sics("7841")=>"7841",
				Company.four_digit_sics("7911")=>"7911",
				Company.four_digit_sics("7922")=>"7922",
				Company.four_digit_sics("7929")=>"7929",
				Company.four_digit_sics("7933")=>"7933",
				Company.four_digit_sics("7941")=>"7941",
				Company.four_digit_sics("7948")=>"7948",
				Company.four_digit_sics("7991")=>"7991",
				Company.four_digit_sics("7992")=>"7992",
				Company.four_digit_sics("7993")=>"7993",
				Company.four_digit_sics("7996")=>"7996",
				Company.four_digit_sics("7997")=>"7997",
				Company.four_digit_sics("7999")=>"7999",
				Company.four_digit_sics("8011")=>"8011",
				Company.four_digit_sics("8021")=>"8021",
				Company.four_digit_sics("8031")=>"8031",
				Company.four_digit_sics("8041")=>"8041",
				Company.four_digit_sics("8042")=>"8042",
				Company.four_digit_sics("8043")=>"8043",
				Company.four_digit_sics("8049")=>"8049",
				Company.four_digit_sics("8051")=>"8051",
				Company.four_digit_sics("8052")=>"8052",
				Company.four_digit_sics("8059")=>"8059",
				Company.four_digit_sics("8062")=>"8062",
				Company.four_digit_sics("8063")=>"8063",
				Company.four_digit_sics("8069")=>"8069",
				Company.four_digit_sics("8071")=>"8071",
				Company.four_digit_sics("8072")=>"8072",
				Company.four_digit_sics("8082")=>"8082",
				Company.four_digit_sics("8092")=>"8092",
				Company.four_digit_sics("8093")=>"8093",
				Company.four_digit_sics("8099")=>"8099",
				Company.four_digit_sics("8111")=>"8111",
				Company.four_digit_sics("8211")=>"8211",
				Company.four_digit_sics("8221")=>"8221",
				Company.four_digit_sics("8222")=>"8222",
				Company.four_digit_sics("8231")=>"8231",
				Company.four_digit_sics("8243")=>"8243",
				Company.four_digit_sics("8244")=>"8244",
				Company.four_digit_sics("8249")=>"8249",
				Company.four_digit_sics("8299")=>"8299",
				Company.four_digit_sics("8322")=>"8322",
				Company.four_digit_sics("8331")=>"8331",
				Company.four_digit_sics("8351")=>"8351",
				Company.four_digit_sics("8361")=>"8361",
				Company.four_digit_sics("8399")=>"8399",
				Company.four_digit_sics("8412")=>"8412",
				Company.four_digit_sics("8422")=>"8422",
				Company.four_digit_sics("8611")=>"8611",
				Company.four_digit_sics("8621")=>"8621",
				Company.four_digit_sics("8631")=>"8631",
				Company.four_digit_sics("8641")=>"8641",
				Company.four_digit_sics("8651")=>"8651",
				Company.four_digit_sics("8661")=>"8661",
				Company.four_digit_sics("8699")=>"8699",
				Company.four_digit_sics("8711")=>"8711",
				Company.four_digit_sics("8712")=>"8712",
				Company.four_digit_sics("8713")=>"8713",
				Company.four_digit_sics("8721")=>"8721",
				Company.four_digit_sics("8731")=>"8731",
				Company.four_digit_sics("8732")=>"8732",
				Company.four_digit_sics("8733")=>"8733",
				Company.four_digit_sics("8734")=>"8734",
				Company.four_digit_sics("8741")=>"8741",
				Company.four_digit_sics("8742")=>"8742",
				Company.four_digit_sics("8743")=>"8743",
				Company.four_digit_sics("8744")=>"8744",
				Company.four_digit_sics("8748")=>"8748",
				Company.four_digit_sics("8811")=>"8811",
				Company.four_digit_sics("8999")=>"8999",
				Company.four_digit_sics("9111")=>"9111",
				Company.four_digit_sics("9121")=>"9121",
				Company.four_digit_sics("9131")=>"9131",
				Company.four_digit_sics("9199")=>"9199",
				Company.four_digit_sics("9211")=>"9211",
				Company.four_digit_sics("9221")=>"9221",
				Company.four_digit_sics("9222")=>"9222",
				Company.four_digit_sics("9223")=>"9223",
				Company.four_digit_sics("9224")=>"9224",
				Company.four_digit_sics("9229")=>"9229",
				Company.four_digit_sics("9311")=>"9311",
				Company.four_digit_sics("9411")=>"9411",
				Company.four_digit_sics("9431")=>"9431",
				Company.four_digit_sics("9441")=>"9441",
				Company.four_digit_sics("9451")=>"9451",
				Company.four_digit_sics("9511")=>"9511",
				Company.four_digit_sics("9512")=>"9512",
				Company.four_digit_sics("9531")=>"9531",
				Company.four_digit_sics("9532")=>"9532",
				Company.four_digit_sics("9611")=>"9611",
				Company.four_digit_sics("9621")=>"9621",
				Company.four_digit_sics("9631")=>"9631",
				Company.four_digit_sics("9641")=>"9641",
				Company.four_digit_sics("9651")=>"9651",
				Company.four_digit_sics("9661")=>"9661",
				Company.four_digit_sics("9711")=>"9711",
				Company.four_digit_sics("9721")=>"9721",
				Company.four_digit_sics("9999")=>"9999"
			}
		end


end
