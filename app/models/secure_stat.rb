#This is the model for the secure data a user will enter about a company
# this data will be encrypted with a user's secondary data password
class SecureStat < Stat
  validate :datacheck

  #if an updated field is the CY's fye, update all secure and trade stat
  #fye (other than "now") 
  on_update do
    if self.year = 1 and self.fye_changed?
      comp = self.company 
      2y = SecureStat.find(comp.secure_2y_id)
      3y = SecureStat.find(comp.secure_3y_id)
      4y = SecureStat.find(comp.secure_4y_id)
      5y = SecureStat.find(comp.secure_5y_id)
      2y.fye = "1/#{self.fye.month}/#{self.fye.year-1}".to_datetime
      3y.fye = "1/#{self.fye.month}/#{self.fye.year-2}".to_datetime
      4y.fye = "1/#{self.fye.month}/#{self.fye.year-3}".to_datetime
      5y.fye = "1/#{self.fye.month}/#{self.fye.year-4}".to_datetime
      trade_2y = TradeStat.find(comp.trade_2y_id)
      trade_3y = TradeStat.find(comp.trade_3y_id)
      trade_4y = TradeStat.find(comp.trade_4y_id)
      trade_5y = TradeStat.find(comp.trade_5y_id)
      trade_2y.fye=2y.fye
      trade_3y.fye=3y.fye
      trade_4y.fye=4y.fye
      trade_5y.fye=5y.fye
      2y.save
      3y.save
      4y.save
      5y.save
      trade_2y.save
      trade_3y.save
      trade_4y.save
      trade_5y.save

      trade_cy = TradeStat.find(comp.trade_cy_id)
      trade_cy.fye = self.fye
      trade_cy.save
      self.save
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

end