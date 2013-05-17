class Account < ActiveRecord::Base
  validate :login, :email, :presence => true

  has_secure_password

  has_many :sessions
end
