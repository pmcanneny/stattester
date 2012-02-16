#this is the parrent class for the secure_stat and trade_stat classes
#all functionality commmon to these classes goes here
class Stat < ActiveRecord::Base
  belongs_to :company
  validates_presence_of :company_id

  #define the options for year
  def self.year(y)
	case y
	when 0
		"now"
	when 1
		"cy"
	when 2
		"2y"
	when 3
		"3y"
	when 4
		"4y"
	when 5
		"5y"
	end
  end
  #year options in hash form - for use in drop-down menus
  def self.year_options
  	{Stat.year(0)=>0,Stat.year(1)=>1,Stat.year(2)=>2,Stat.year(3)=>3,Stat.year(4)=>4,Stat.year(5)=>5}
  end

  #define the options for Input Basis
  def self.input_basis(i)
	case i
	when 1
		"Transaction Based"
	when 2
		"My Estimate"
	end
  end
  #input_basis options in hash form - for use in drop-down menus
  def self.input_basis_options
  	{Stat.input_basis(1)=>1,Stat.input_basis(2)=>2}
  end

  #define the options for quality
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
  	{Stat.quality(1)=>1,Stat.quality(2)=>2,Stat.quality(3)=>3}
  end

  #define the options for reporting scale
  def self.reporting_scale(s)
	case s
	when 1
		"Dollars"
	when 2
		"Thousands of Dollars"
	when 3
		"Millions of Dollars"
	when 4
		"Billions of Dollars"
	end
  end
  #define the scale - for use in calculations
  def self.scale(s)
	case s
	when 1
		1
	when 2
		1000
	when 3
		1000000
	when 4
		1000000000
	end
  end
  #scale options in hash form - for use in drop-down menus
  def self.reporting_scale_options
  	{Stat.reporting_scale(1)=>1,Stat.reporting_scale(2)=>2,Stat.reporting_scale(3)=>3,Stat.reporting_scale(4)=>4}
  end

end