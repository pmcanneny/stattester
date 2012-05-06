#This is the model for the stats that will be shared anonymously for use in 
# calculating network stats
class TradeStat < ActiveRecord::Base
  belongs_to :company
  validates_presence_of :company_id

  #method takes TradeStat data and returns if it is valid or not to be used in network stats
  def self.valid?(data)
    !data.nil?
  end

  #this method calculates and updates the trade stats
  def calculate_stats!(base_stats)
  	#Revenue Category - using Gross Sales
  	#spacing used for readability
  	#starts with category 1 being less than 1million in sales
  	#ends with catefory 12 being more than 2billion in sales
  	unless base_stats.gross_sales.nil?
  	  if 	base_stats.gross_sales*SecureStat.scale(base_stats.reporting_scale)   < 1 	*1000000
  	    self.revenue_category = 1
  	  elsif base_stats.gross_sales*SecureStat.scale(base_stats.reporting_scale) < 5 	*1000000
  	    self.revenue_category = 2
  	  elsif base_stats.gross_sales*SecureStat.scale(base_stats.reporting_scale) < 10	*1000000
  	    self.revenue_category = 3
  	  elsif base_stats.gross_sales*SecureStat.scale(base_stats.reporting_scale) < 30	*1000000
  	    self.revenue_category = 4
  	  elsif base_stats.gross_sales*SecureStat.scale(base_stats.reporting_scale) < 75	*1000000
  	    self.revenue_category = 5
  	  elsif base_stats.gross_sales*SecureStat.scale(base_stats.reporting_scale) < 100 *1000000
  	    self.revenue_category = 6
  	  elsif base_stats.gross_sales*SecureStat.scale(base_stats.reporting_scale) < 150 *1000000
  	    self.revenue_category = 7
  	  elsif base_stats.gross_sales*SecureStat.scale(base_stats.reporting_scale) < 250 *1000000
  	    self.revenue_category = 8
  	  elsif base_stats.gross_sales*SecureStat.scale(base_stats.reporting_scale) < 500 *1000000
  	    self.revenue_category = 9
  	  elsif base_stats.gross_sales*SecureStat.scale(base_stats.reporting_scale) < 1000*1000000
  	    self.revenue_category = 10
  	  elsif base_stats.gross_sales*SecureStat.scale(base_stats.reporting_scale) < 2000*1000000
  	    self.revenue_category = 11
	  else
	    self.revenue_category = 12
	  end
	end
	#Asset Category - using Assets
	#spacing used for readability
  	#starts with category 1 being less than 1million in assets
  	#ends with catefory 12 being more than 2billion in assets
	unless base_stats.assets.nil?
  	  if 	base_stats.assets*SecureStat.scale(base_stats.reporting_scale)   < 1   *1000000
  	    self.asset_category = 1
  	  elsif base_stats.assets*SecureStat.scale(base_stats.reporting_scale) < 5   *1000000
  	    self.asset_category = 2
  	  elsif base_stats.assets*SecureStat.scale(base_stats.reporting_scale) < 10  *1000000
  	    self.asset_category = 3
  	  elsif base_stats.assets*SecureStat.scale(base_stats.reporting_scale) < 30  *1000000
  	    self.asset_category = 4
  	  elsif base_stats.assets*SecureStat.scale(base_stats.reporting_scale) < 75  *1000000
  	    self.asset_category = 5
  	  elsif base_stats.assets*SecureStat.scale(base_stats.reporting_scale) < 100 *1000000
  	    self.asset_category = 6
  	  elsif base_stats.assets*SecureStat.scale(base_stats.reporting_scale) < 150 *1000000
  	    self.asset_category = 7
  	  elsif base_stats.assets*SecureStat.scale(base_stats.reporting_scale) < 250 *1000000
  	    self.asset_category = 8
  	  elsif base_stats.assets*SecureStat.scale(base_stats.reporting_scale) < 500 *1000000
  	    self.asset_category = 9
  	  elsif base_stats.assets*SecureStat.scale(base_stats.reporting_scale) < 1000*1000000
  	    self.asset_category = 10
  	  elsif base_stats.assets*SecureStat.scale(base_stats.reporting_scale) < 2000*1000000
  	    self.asset_category = 11
	  else
	    self.asset_category = 12
	  end
	end
	#Sales/Revenue Growth
	unless base_stats.gross_sales.nil? or base_stats.prev_year.nil? or base_stats.prev_year.gross_sales.nil? or base_stats.prev_year.gross_sales==0
	  self.sales_growth = ((base_stats.gross_sales.to_f/base_stats.prev_year.gross_sales.to_f-1)*100)
	end
	#Gross Profit Margin
	unless base_stats.gross_sales.nil? or base_stats.gross_profit.nil? or base_stats.gross_sales==0
	  self.gross_profit_margin = (base_stats.gross_profit.to_f/base_stats.gross_sales.to_f)*100
	end
	#Operating Profit Margin
	unless base_stats.gross_sales.nil? or base_stats.operating_profit.nil? or base_stats.gross_sales==0
	  self.operating_profit_margin = (base_stats.operating_profit.to_f/base_stats.gross_sales.to_f)*100
	end
	#EBITDA%
	unless base_stats.ebitda.nil? or base_stats.gross_sales.nil? or base_stats.gross_sales==0
	  self.ebitda_percent = (base_stats.ebitda.to_f/base_stats.gross_sales.to_f)*100
	end
	#Enterprise Multiple of Book

	#My EBITDA Multiple
	unless base_stats.ebitda_multiple.nil?
	  self.ebitda_multiple = base_stats.ebitda_multiple
	end
	#My Sales Multiple
	unless base_stats.sales_multiple.nil?
	  self.sales_multiple = base_stats.sales_multiple
	end
	#My Funded Debt Multiple
	unless base_stats.debt_multiple.nil?
	  self.debt_multiple = base_stats.debt_multiple
	end

  self.quality = base_stats.quality
  self.quality = 1 if self.quality.nil?

	self.save
  end
end