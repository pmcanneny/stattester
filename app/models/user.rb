class User < ActiveRecord::Base
  has_secure_password
  has_many :companies
  has_many :stat_filters

  validates_presence_of :password, :on => :create
  validates_presence_of :email, :on => :create
  validates_presence_of :subtype, :on => :create, :message => "Must select classification"
  validates_uniqueness_of :email, :on => :create
  validates_format_of :email, :with => /^.+@.+\..+$/, :on => :create
  validates_length_of :password, :within => 4..16, :on => :create
  validates_confirmation_of :email, :on => :create

  #generate activation code upon creation
  after_create do
  	self.generate_activation_code
  end

  #generates random big hex string as activation code
  def generate_activation_code
  	#self.activation_code = Random.rand(1000000-9999999)+1000000
    self.activation_code = SecureRandom.hex(10)
  	self.save
  end

  #generates random big hex string as reset password code
  def generate_reset_password_code
    self.reset_password = true
    self.reset_password_code = SecureRandom.hex(12)
    self.save
  end

  #tries to activate account given activation code
  #returns true if successful, false if not
  def activate(code)
  	if self.activation_code.to_i == code.to_i
  	  self.activated = true
  	  self.save
  	  true
  	else
  	  false
  	end
  end

  #different subtypes for a user
  def self.subtype(o)
    case o
    when 1
      "CPA in Public Practice"
    when 2
      "Investment Banker"
    when 3
      "Business Broker"
    when 4
      "Business Appraiser or Valuation Expert"
    when 5
      "Commercial and/or Mezzanine Lender"
    when 6
      "Private Investor or Private Equity Professional"
    when 7
      "Public Investor or Investment Manager"
    when 8
      "Financial Professional Working in Industry"
    when 9
      "Executive Working in Industry"
    when 10
      "Attorney"
    when 11
      "Consultant or Financial Analyst"
    when 12
      "Not Classified"
    end
  end

  #user subtype in hash form - for use in drop-down menus
  def self.subtype_options
    {User.subtype(1)=>1,User.subtype(2)=>2,User.subtype(3)=>3,User.subtype(4)=>4,User.subtype(5)=>5,User.subtype(6)=>6,
      User.subtype(7)=>7,User.subtype(8)=>8,User.subtype(9)=>9,User.subtype(10)=>10,User.subtype(11)=>11,User.subtype(12)=>12}
  end

  #translate the user subtype to the user types
  def self.type(t)
    case t
    when 1
      # "CPA in Public Practice"
      1 # Licensee
    when 2
      # "Investment Banker "
      1 # Licensee
    when 3
      # "Business Broker"
      1 # Licensee
    when 4
      # "Business Appraiser/Valuation Expert"
      2 # Financial
    when 5
      # "Commercial &/or Mezzanine Lender"
      2 # Financial
    when 6
      # "Private Investor or Private Equity Professional"
      2 # Financial
    when 7
      # "Public Investor or Investment Manager"
      2 # Financial
    when 8
      # "Financial Professional Working in Industry"
      3 # Commercial
    when 9
      # "Executive Working in Industry"
      3 # Commercial
    when 10
      # "Attorney"
      4 # Analyst
    when 11
      # "Consultant or Financial Analyst"
      4 # Analyst
    when 12
      # "Not Classified"
      4 # Analyst
    end
  end

end
