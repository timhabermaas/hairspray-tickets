class Reservation < ActiveRecord::Base
  belongs_to :seat
  belongs_to :order

  validates_presence_of :order_id, :seat_id
end
