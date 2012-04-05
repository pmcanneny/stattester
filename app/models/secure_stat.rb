#This is the model for the secure data a user will enter about a company
# this data will be encrypted with a user's secondary data password
class SecureStat < ActiveRecord::Base
  belongs_to :company
  validates_presence_of :company_id
  validate :datacheck

  #validate fye and company ID combination is unique

  #if an updated field is the CY's fye, update all secure and trade stat
  #fye (other than "now") 
  before_save do
    if self.year == 1 and (self.fye.to_s != self.fye_was.to_s) and !(self.fye.nil?)
      comp = self.company 
      y2 = SecureStat.find(comp.secure_2y_id)
      y3 = SecureStat.find(comp.secure_3y_id)
      y4 = SecureStat.find(comp.secure_4y_id)
      y5 = SecureStat.find(comp.secure_5y_id)
      y2.fye = "1/#{self.fye.month}/#{self.fye.year-1}".to_datetime
      y3.fye = "1/#{self.fye.month}/#{self.fye.year-2}".to_datetime
      y4.fye = "1/#{self.fye.month}/#{self.fye.year-3}".to_datetime
      y5.fye = "1/#{self.fye.month}/#{self.fye.year-4}".to_datetime
      trade_cy = TradeStat.find(comp.trade_cy_id)
      trade_2y = TradeStat.find(comp.trade_2y_id)
      trade_3y = TradeStat.find(comp.trade_3y_id)
      trade_4y = TradeStat.find(comp.trade_4y_id)
      trade_5y = TradeStat.find(comp.trade_5y_id)
      trade_cy.fye = self.fye
      trade_2y.fye=y2.fye
      trade_3y.fye=y3.fye
      trade_4y.fye=y4.fye
      trade_5y.fye=y5.fye
      y2.save
      y3.save
      y4.save
      y5.save
      trade_cy.save
      trade_2y.save
      trade_3y.save
      trade_4y.save
      trade_5y.save      
    end
    # if self.year = 1 and self.fye_changed?
    #   comp = self.company
    #   %w{} 
  end

  #this is the validation method in which we will check the scanity of the data fields
  def datacheck
  	#Initial scanity check: do nothing
  	#unless self.gross_sales.nil?
	  #if self.gross_sales < 0
	   # errors.add(:gross_sales, "Cannot be a negative number")
	  #end
	  #end
  end
  
  #define the options for reporting scale
  def self.reporting_scale(s)
    case s
    when 1
      "$0" #dollars
    when 2
      "$000" #thousands of dollars
    when 3
      "$000000" #millions of dollars
    when 4
      "$000000000" #billions of dollars
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
    {SecureStat.reporting_scale(1)=>1,SecureStat.reporting_scale(2)=>2,SecureStat.reporting_scale(3)=>3,SecureStat.reporting_scale(4)=>4}
  end

  #this returns 0 for now, 1 for CY, 2 for 2Y, 3 for 3Y etc
  def year
    case self.id
    when self.company.secure_now_id
      0
    when self.company.secure_cy_id
      1
    when self.company.secure_2y_id
      2
    when self.company.secure_3y_id
      3
    when self.company.secure_4y_id
      4
    when self.company.secure_5y_id
      5
    else
      -1
    end
  end

  #this returns the SecureStat for the previous year
  #if this is year5 (no previous year) return nil
  def prev_year
  	case self.year
  	when 0
  	  SecureStat.find(self.company.secure_cy_id)
  	when 1
  	  SecureStat.find(self.company.secure_2y_id)
  	when 2
  	  SecureStat.find(self.company.secure_3y_id)
  	when 3
  	  SecureStat.find(self.company.secure_4y_id)
  	when 4
  	  SecureStat.find(self.company.secure_5y_id)
  	when 5
  	  nil
  	end
  end

  #this returns the SecureStat for the next year
  #if this is year0 (no next year) return nil
  def next_year
  	case self.year
  	when 0
  	  nil
  	when 1
  	  SecureStat.find(self.company.secure_new_id)
  	when 2
  	  SecureStat.find(self.company.secure_cy_id)
  	when 3
  	  SecureStat.find(self.company.secure_2y_id)
  	when 4
  	  SecureStat.find(self.company.secure_3y_id)
  	when 5
  	  SecureStat.find(self.company.secure_4y_id)
  	end
  end

  #find the current year's fiscal year end; that which the other fiscal year ends are based on
  def cy_fye
    if self.year == 1
      self.fye
    else
      SecureStat.find(self.company.secure_cy_id).fye
    end
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
    {SecureStat.quality(1)=>1,SecureStat.quality(2)=>2,SecureStat.quality(3)=>3}
  end

 

end