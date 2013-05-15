class Reservation < ActiveRecord::Base
  belongs_to :seat
  belongs_to :order, :counter_cache => true
end
