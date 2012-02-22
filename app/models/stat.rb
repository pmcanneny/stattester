#this class contains "helper" functions that have logic used in association with 
#the secure stat and trade stat classes
class Stat 
  
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

  

end