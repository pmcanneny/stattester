#a filter object for use in network stats
class StatFilter < ActiveRecord::Base
  belongs_to :company
  validates_presence_of :name

  #calculate the sic parent on update
  before_save do 

    self.sic_level1 = "" if self.sic_level1.nil?
    self.sic_level2 = "" if self.sic_level2.nil?
    self.sic_level3 = "" if self.sic_level3.nil?
    self.sic_level4 = "" if self.sic_level4.nil?

    if self.sic_level4 != ""
      self.sic_parent = self.sic_level4
    elsif self.sic_level3 != ""
      self.sic_parent = self.sic_level3
    elsif self.sic_level2 != ""
      self.sic_parent = self.sic_level2
    elsif self.sic_level1 != ""
      self.sic_parent = self.sic_level1
    else
      self.sic_parent = ""
    end
  end
  
  #define the options for Reporting Entity
  def self.combination(r)
  	unless r == 0
  	  Company.combination(r)
  	else
  	  "Any"
  	end
  end
  #combination options in hash form - for use in drop-down menus
  def self.combination_options
  	{StatFilter.combination(0)=>0,StatFilter.combination(1)=>1,StatFilter.combination(2)=>2}
  end

  #define the options for Ownership
  def self.ownership(o)
  	unless o == 0
  	  Company.ownership(o)
  	else
  	  "Any"
  	end
  end
  #ownership options in hash form - for use in drop-down menus
  def self.ownership_options
  	{StatFilter.ownership(0)=>0,StatFilter.ownership(1)=>1,StatFilter.ownership(2)=>2,StatFilter.ownership(3)=>3}
  end

  #define the options for Region
  def self.region(r)
  	unless r == 0
  	  Company.region(r)
  	else
  	  "Any"
  	end
  end
  #region options in hash form - for use in drop-down menus
  def self.region_options
  	{StatFilter.region(0)=>0,StatFilter.region(1)=>1,StatFilter.region(2)=>2,StatFilter.region(3)=>3,
	 StatFilter.region(4)=>4,StatFilter.region(5)=>5,StatFilter.region(6)=>6,StatFilter.region(7)=>7}
  end

  #define the options for Country
  def self.country(c)
  	unless c == 0
  	  Company.country(c)
  	else
  	  "Any"
  	end
  end
  #Country options in hash form - for use in drop-down menus
  def self.country_options
  	{StatFilter.country(0)=>0,StatFilter.country(1)=>1}
  end

  #define the options for Historical Quality
  def self.quality(q)
    unless q == 0
  	  SecureStat.quality(q)
  	else
  	  "Any"
  	end
  end

  #quality options in hash form - for use in drop-down menus
  def self.quality_options
    {StatFilter.quality(0)=>0,StatFilter.quality(1)=>1,StatFilter.quality(2)=>2,StatFilter.quality(3)=>3}
  end

end