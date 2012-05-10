require 'spreadsheet'
Spreadsheet.client_encoding = 'UTF-8'

class Company < ActiveRecord::Base
  belongs_to :user
  validates_presence_of :name
  validates_presence_of :user_id
  validates_presence_of :ownership, :on => :create


  after_create do
		self.current_filter_id = self.current_filter
		self.save
  end

  #################################################################
  # singleton patterns for the current filter, and stats
  #
  #
  def current_filter
  	unless self.current_filter_id == nil or (StatFilter.find(current_filter_id) rescue nil) == nil
  		self.current_filter_id
  	else
  		filter = StatFilter.new
			filter.name = "default"
			filter.country = 0
			filter.region = 0
			filter.revenue_low = 0
			filter.revenue_high = 0
			filter.asset_low = 0
			filter.asset_high = 0
			filter.sic_parent = ""
			filter.sic_level1 = ""
			filter.sic_level2 = ""
			filter.sic_level3 = ""
			filter.sic_level4 = ""
			filter.save
			filter.company_id = self.id
			filter.default_settings!
			self.current_filter_id = filter.id
			self.save
			self.current_filter_id
		end
	end
	def trade_now
		unless self.trade_now_id == nil or (TradeStat.find(trade_now_id) rescue nil) == nil
			self.trade_now_id
		else
			trade=TradeStat.new
			trade.company_id = self.id
			trade.save
			self.trade_now_id = trade.id
			self.save
			self.trade_now_id
		end
	end
	def trade_cy
		unless self.trade_cy_id == nil or (TradeStat.find(trade_cy_id) rescue nil) == nil
			self.trade_cy_id
		else
			trade=TradeStat.new
			trade.company_id = self.id
			trade.save
			self.trade_cy_id = trade.id
			self.save
			self.trade_cy_id
		end
	end
	def trade_2y
		unless self.trade_2y_id == nil or (TradeStat.find(trade_2y_id) rescue nil) == nil
			self.trade_2y_id
		else
			trade=TradeStat.new
			trade.company_id = self.id
			trade.save
			self.trade_2y_id = trade.id
			self.save
			self.trade_2y_id
		end
	end
	def trade_3y
		#temp = TradeStat.find(id) rescue nil
		unless self.trade_3y_id == nil or (TradeStat.find(trade_3y_id) rescue nil) == nil
			self.trade_3y_id
		else
			trade=TradeStat.new
			trade.company_id = self.id
			trade.save
			self.trade_3y_id = trade.id
			self.save
			self.trade_3y_id
		end
	end
	def trade_4y
		unless self.trade_4y_id == nil or (TradeStat.find(trade_4y_id) rescue nil) == nil
			self.trade_4y_id
		else
			trade=TradeStat.new
			trade.company_id = self.id
			trade.save
			self.trade_4y_id = trade.id
			self.save
			self.trade_4y_id
		end
	end
	def trade_5y
		unless self.trade_5y_id == nil or (TradeStat.find(trade_5y_id) rescue nil) == nil
			self.trade_5y_id
		else
			trade=TradeStat.new
			trade.company_id = self.id
			trade.save
			self.trade_5y_id = trade.id
			self.save
			self.trade_5y_id
		end
	end
	def secure_now
		unless self.secure_now_id == nil or (SecureStat.find(secure_now_id) rescue nil) == nil
			self.secure_now_id
		else
			secure=SecureStat.new
			secure.company_id = self.id
			secure.save
			self.secure_now_id = secure.id
			self.save
			self.secure_now_id
		end
	end
	def secure_cy
		unless self.secure_cy_id == nil or (SecureStat.find(secure_cy_id) rescue nil) == nil
			self.secure_cy_id
		else
			secure=SecureStat.new
			secure.company_id = self.id
			secure.save
			self.secure_cy_id = secure.id
			self.save
			self.secure_cy_id
		end
	end
	def secure_2y
		unless self.secure_2y_id == nil or (SecureStat.find(secure_2y_id) rescue nil) == nil
			self.secure_2y_id
		else
			secure=SecureStat.new
			secure.company_id = self.id
			secure.save
			self.secure_2y_id = secure.id
			self.save
			self.secure_2y_id
		end
	end
	def secure_3y
		unless self.secure_3y_id == nil or (SecureStat.find(secure_3y_id) rescue nil) == nil
			self.secure_3y_id
		else
			secure=SecureStat.new
			secure.company_id = self.id
			secure.save
			self.secure_3y_id = secure.id
			self.save
			self.secure_3y_id
		end
	end
	def secure_4y
		unless self.secure_4y_id == nil or (SecureStat.find(secure_4y_id) rescue nil) == nil
			self.secure_4y_id
		else
			secure=SecureStat.new
			secure.company_id = self.id
			secure.save
			self.secure_4y_id = secure.id
			self.save
			self.secure_4y_id
		end
	end
	def secure_5y
		unless self.secure_5y_id == nil or (SecureStat.find(secure_5y_id) rescue nil) == nil
			self.secure_5y_id
		else
			secure=SecureStat.new
			secure.company_id = self.id
			secure.save
			self.secure_5y_id = secure.id
			self.save
			self.secure_5y_id
		end
	end
	#
	# end singleton patterns
	##################################################################

	#export to xml stattrader format
	def stattrader_xml

		secure_now= SecureStat.find(self.secure_now)
		secure_cy = SecureStat.find(self.secure_cy)
  	secure_2y = SecureStat.find(self.secure_2y)
  	secure_3y = SecureStat.find(self.secure_3y)
  	secure_4y = SecureStat.find(self.secure_4y)
  	secure_5y = SecureStat.find(self.secure_5y)

		"
			<stattrader>
				<profile>
					<name>#{self.name}</name> 
					<alias>#{self.name}</alias>
					<combination>#{self.combination}</combination> 
					<ownership>#{self.ownership}</ownership>
					<sic>#{self.sic}</sic>
					<country>#{self.country}</country> 
					<region>#{self.region}</region> 
			    <state>#{self.state}</state> 
			    <zipcode>#{self.zipcode}</zipcode> 
					<ticker_symbol>#{self.ticker_symbol}</ticker_symbol> 
					<CIK>#{self.CIK}</CIK>
				</profile>
				
				<company_data fye=\"#{secure_now.fye.nil? ? nil : secure_now.fye.month.to_s+'/'+secure_now.fye.day.to_s+'/'+secure_now.fye.year.to_s}\">
					<reporting_scale>#{secure_now.reporting_scale}</reporting_scale> 
					<input_basis>#{secure_now.input_basis}</input_basis>
					<quality>#{secure_now.quality}</quality> 
					<assets>#{secure_now.assets}</assets>
					<gross_sales>#{secure_now.gross_sales}</gross_sales> 
					<gross_profit>#{secure_now.gross_profit}</gross_profit>
					<operating_profit>#{secure_now.operating_profit}</operating_profit>
					<ebitda>#{secure_now.ebitda}</ebitda>
					<stock_price>#{secure_now.stock_price}</stock_price>
					<sales_multiple>#{secure_now.sales_multiple}</sales_multiple>
					<ebitda_multiple>#{secure_now.ebitda_multiple}</ebitda_multiple>
					<debt_multiple>#{secure_now.debt_multiple}</debt_multiple>
				</company_data>
				<company_data fye=\"#{secure_cy.fye.nil? ? nil : secure_cy.fye.month.to_s+'/'+secure_cy.fye.day.to_s+'/'+secure_cy.fye.year.to_s}\">
					<reporting_scale>#{secure_cy.reporting_scale}</reporting_scale> 
					<input_basis>#{secure_cy.input_basis}</input_basis>
					<quality>#{secure_cy.quality}</quality> 
					<assets>#{secure_cy.assets}</assets>
					<gross_sales>#{secure_cy.gross_sales}</gross_sales> 
					<gross_profit>#{secure_cy.gross_profit}</gross_profit>
					<operating_profit>#{secure_cy.operating_profit}</operating_profit>
					<ebitda>#{secure_cy.ebitda}</ebitda>
					<stock_price>#{secure_cy.stock_price}</stock_price>
					<sales_multiple>#{secure_cy.sales_multiple}</sales_multiple>
					<ebitda_multiple>#{secure_cy.ebitda_multiple}</ebitda_multiple>
					<debt_multiple>#{secure_cy.debt_multiple}</debt_multiple>
				</company_data>
				<company_data fye=\"#{secure_2y.fye.nil? ? nil : secure_2y.fye.month.to_s+'/'+secure_2y.fye.day.to_s+'/'+secure_2y.fye.year.to_s}\">
					<reporting_scale>#{secure_2y.reporting_scale}</reporting_scale> 
					<input_basis>#{secure_2y.input_basis}</input_basis>
					<quality>#{secure_2y.quality}</quality> 
					<assets>#{secure_2y.assets}</assets>
					<gross_sales>#{secure_2y.gross_sales}</gross_sales> 
					<gross_profit>#{secure_2y.gross_profit}</gross_profit>
					<operating_profit>#{secure_2y.operating_profit}</operating_profit>
					<ebitda>#{secure_2y.ebitda}</ebitda>
					<stock_price>#{secure_2y.stock_price}</stock_price>
					<sales_multiple>#{secure_2y.sales_multiple}</sales_multiple>
					<ebitda_multiple>#{secure_2y.ebitda_multiple}</ebitda_multiple>
					<debt_multiple>#{secure_2y.debt_multiple}</debt_multiple>
				</company_data>
				<company_data fye=\"#{secure_3y.fye.nil? ? nil : secure_3y.fye.month.to_s+'/'+secure_3y.fye.day.to_s+'/'+secure_3y.fye.year.to_s}\">
					<reporting_scale>#{secure_3y.reporting_scale}</reporting_scale> 
					<input_basis>#{secure_3y.input_basis}</input_basis>
					<quality>#{secure_3y.quality}</quality> 
					<assets>#{secure_3y.assets}</assets>
					<gross_sales>#{secure_3y.gross_sales}</gross_sales> 
					<gross_profit>#{secure_3y.gross_profit}</gross_profit>
					<operating_profit>#{secure_3y.operating_profit}</operating_profit>
					<ebitda>#{secure_3y.ebitda}</ebitda>
					<stock_price>#{secure_3y.stock_price}</stock_price>
					<sales_multiple>#{secure_3y.sales_multiple}</sales_multiple>
					<ebitda_multiple>#{secure_3y.ebitda_multiple}</ebitda_multiple>
					<debt_multiple>#{secure_3y.debt_multiple}</debt_multiple>
				</company_data>
				<company_data fye=\"#{secure_4y.fye.nil? ? nil : secure_4y.fye.month.to_s+'/'+secure_4y.fye.day.to_s+'/'+secure_4y.fye.year.to_s}\">
					<reporting_scale>#{secure_4y.reporting_scale}</reporting_scale> 
					<input_basis>#{secure_4y.input_basis}</input_basis>
					<quality>#{secure_4y.quality}</quality> 
					<assets>#{secure_4y.assets}</assets>
					<gross_sales>#{secure_4y.gross_sales}</gross_sales> 
					<gross_profit>#{secure_4y.gross_profit}</gross_profit>
					<operating_profit>#{secure_4y.operating_profit}</operating_profit>
					<ebitda>#{secure_4y.ebitda}</ebitda>
					<stock_price>#{secure_4y.stock_price}</stock_price>
					<sales_multiple>#{secure_4y.sales_multiple}</sales_multiple>
					<ebitda_multiple>#{secure_4y.ebitda_multiple}</ebitda_multiple>
					<debt_multiple>#{secure_4y.debt_multiple}</debt_multiple>
				</company_data>
				<company_data fye=\"#{secure_5y.fye.nil? ? nil : secure_5y.fye.month.to_s+'/'+secure_5y.fye.day.to_s+'/'+secure_5y.fye.year.to_s}\">
					<reporting_scale>#{secure_5y.reporting_scale}</reporting_scale> 
					<input_basis>#{secure_5y.input_basis}</input_basis>
					<quality>#{secure_5y.quality}</quality> 
					<assets>#{secure_5y.assets}</assets>
					<gross_sales>#{secure_5y.gross_sales}</gross_sales> 
					<gross_profit>#{secure_5y.gross_profit}</gross_profit>
					<operating_profit>#{secure_5y.operating_profit}</operating_profit>
					<ebitda>#{secure_5y.ebitda}</ebitda>
					<stock_price>#{secure_5y.stock_price}</stock_price>
					<sales_multiple>#{secure_5y.sales_multiple}</sales_multiple>
					<ebitda_multiple>#{secure_5y.ebitda_multiple}</ebitda_multiple>
					<debt_multiple>#{secure_5y.debt_multiple}</debt_multiple>
				</company_data>
			</stattrader>
		"
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
	 	sheet1[4,2] = "#{sic} #{SIC.description(sic)}"
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

		secure_now= SecureStat.find(self.secure_now)
		secure_cy = SecureStat.find(self.secure_cy)
  	secure_2y = SecureStat.find(self.secure_2y)
  	secure_3y = SecureStat.find(self.secure_3y)
  	secure_4y = SecureStat.find(self.secure_4y)
  	secure_5y = SecureStat.find(self.secure_5y)

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

	 	trade_now= TradeStat.find(self.trade_now)
  	trade_cy = TradeStat.find(self.trade_cy)
  	trade_2y = TradeStat.find(self.trade_2y)
  	trade_3y = TradeStat.find(self.trade_3y)
  	trade_4y = TradeStat.find(self.trade_4y)
  	trade_5y = TradeStat.find(self.trade_5y)

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
	 	sheet1[4,2] = "#{sic} #{SIC.description(sic)}"
	 	sheet1[5,2] = Company.country(country)
	 	sheet1[6,2] = Company.region(region)

	 	trade_now= TradeStat.find(self.trade_now)
  	trade_cy = TradeStat.find(self.trade_cy)
  	trade_2y = TradeStat.find(self.trade_2y)
  	trade_3y = TradeStat.find(self.trade_3y)
  	trade_4y = TradeStat.find(self.trade_4y)
  	trade_5y = TradeStat.find(self.trade_5y)

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
  	  if ((DateTime.now.year-cy.fye.year)*12 + (DateTime.now.month-cy.fye.month)) > 18
  	  	company.shift_years
  	  end
  	end
  end

  #perform the year shift on the data pieces
  #TODO:complete
  def shift_years
  	secure_cy = SecureStat.find(self.secure_cy)
  	secure_2y = SecureStat.find(self.secure_2y)
  	secure_3y = SecureStat.find(self.secure_3y)
  	secure_4y = SecureStat.find(self.secure_4y)
  	secure_5y = SecureStat.find(self.secure_5y)
  	trade_cy = TradeStat.find(self.trade_cy)
  	trade_2y = TradeStat.find(self.trade_2y)
  	trade_3y = TradeStat.find(self.trade_3y)
  	trade_4y = TradeStat.find(self.trade_4y)
  	trade_5y = TradeStat.find(self.trade_5y)
  	
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
		when 4
			"Division/Subsidiary"
		end
  end
  #ownership options in hash form - for use in drop-down menus
  def self.ownership_options
  	{Company.ownership(1)=>1,Company.ownership(2)=>2,Company.ownership(3)=>3,Company.ownership(4)=>4}
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

end
