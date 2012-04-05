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
	self.default_filter_id = filter.id

	self.save  	
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
		"Yes"
	when 2
		"No"
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

end
