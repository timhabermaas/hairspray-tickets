class Account < ActiveRecord::Base
  validate :login, :email, :role, :presence => true
  validate :role, :inclusion => { :in => %w(user admin) }

  has_secure_password

  has_many :sessions

  def role?(role)
    self.role.to_s == role.to_s
  end
end
