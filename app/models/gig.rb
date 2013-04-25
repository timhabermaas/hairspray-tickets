class Gig < ActiveRecord::Base
  attr_accessible :title, :date

  validates :title, :date, :presence => true

  has_many :orders
end
