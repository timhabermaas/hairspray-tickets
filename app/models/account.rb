class Account < ActiveRecord::Base
  validate :login, :role, :presence => true
  validate :role, :inclusion => { :in => %w(user admin) }
  validates_uniqueness_of :login

  has_secure_password

  has_many :sessions

  def role?(*roles)
    roles.any? do |r|
      self.role.to_s == r.to_s
    end
  end
end
