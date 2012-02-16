class Company < ActiveRecord::Base
  belongs_to :user
  validates_presence_of :name
  validates_presence_of :user_id

  #The greatest numbers of months that CY's financial year end can be in the past
  def self.max_cy_range
  	36
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
	secure_now.year = 0
	secure_now.reporting_scale = 1
	secure_now.save
	secure_cy.company_id = self.id
	secure_cy.year = 1
	secure_cy.reporting_scale = 1
	secure_cy.save
	secure_2y.company_id = self.id
	secure_2y.year = 2
	secure_2y.reporting_scale = 1
	secure_2y.save
	secure_3y.company_id = self.id
	secure_3y.year = 3
	secure_3y.reporting_scale = 1
	secure_3y.save
	secure_4y.company_id = self.id
	secure_4y.year = 4
	secure_4y.reporting_scale = 1
	secure_4y.save
	secure_5y.company_id = self.id
	secure_5y.year = 5
	secure_5y.reporting_scale = 1
	secure_5y.save
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
	trade_now.year = 0
	trade_now.save
	trade_cy.company_id = self.id
	trade_cy.year = 1
	trade_cy.save
	trade_2y.company_id = self.id
	trade_2y.year = 2
	trade_2y.save
	trade_3y.company_id = self.id
	trade_3y.year = 3
	trade_3y.save
	trade_4y.company_id = self.id
	trade_4y.year = 4
	trade_4y.save
	trade_5y.company_id = self.id
	trade_5y.year = 5
	trade_5y.save
	self.trade_now_id = trade_now.id
	self.trade_cy_id = trade_cy.id
	self.trade_2y_id = trade_2y.id
	self.trade_3y_id = trade_3y.id
	self.trade_4y_id = trade_4y.id
	self.trade_5y_id = trade_5y.id

	self.save  	
  end

  #apply default values before saving
  before_save do
  	#country default to 1
  	if self.country.nil?
  	  self.country = 1
  	end
  end

  #the method through which the year shift update is checked and applied
  #all companies are checked and if needed, the shift happens and the shifted companies are flagged
  def self.monthly_update
  	companies = Company.all
  	for company in companies
  	  cy = SecureStat.find(company.secure_cy)
  	  if 
  
  #define the options for Reporting Entity
  def self.reporting_entity(r)
	case r
	when 1
		"Combination"
	when 2
		"Subsidiary"
	end
  end
  #reporting_entity options in hash form - for use in drop-down menus
  def self.reporting_entity_options
  	{Company.reporting_entity(1)=>1,Company.reporting_entity(2)=>2}
  end

  #define the options for Historical Quality
  def self.quality(q)
	case q
	when 1
		"Audit"
	when 2
		"Review"
	when 3
		"Mgt/Compiled"
	end
  end
  #quality options in hash form - for use in drop-down menus
  def self.quality_options
  	{Company.quality(1)=>1,Company.quality(2)=>2,Company.quality(3)=>3}
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
