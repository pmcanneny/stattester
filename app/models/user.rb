class User < ActiveRecord::Base
  has_secure_password
  has_many :companies
  has_many :stat_filters

  validates_presence_of :password, :on => :create
  validates_presence_of :email, :on => :create
  validates_uniqueness_of :email, :on => :create
  validates_format_of :email, :with => /^.+@.+\..+$/, :on => :create
  validates_length_of :password, :within => 4..16, :on => :create
  validates_confirmation_of :email, :on => :create

  #generate activation code upon creation
  after_create do
  	self.generate_activation_code
  end

  #generates random big integer as activation code
  def generate_activation_code
  	self.activation_code = Random.rand(1000000-9999999)+1000000
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

end
