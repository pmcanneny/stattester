class User < ActiveRecord::Base
  has_secure_password
  has_many :companies

  validates_presence_of :password
  validates_presence_of :email
  validates_uniqueness_of :email
end
