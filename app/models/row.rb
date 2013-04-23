class Row < ActiveRecord::Base
  attr_accessible :number, :y

  has_many :seats
end
