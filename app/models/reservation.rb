class Reservation < ActiveRecord::Base
  attr_accessible :order_id, :seat_id

  belongs_to :seat
  belongs_to :order, :counter_cache => true
end
