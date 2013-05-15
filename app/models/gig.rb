class Gig < ActiveRecord::Base
  validates :title, :date, :presence => true

  has_many :orders

  def reserved_seats
    orders.inject(0) { |sum, o|  sum + o.seats_count }
  end

  def free_seats
    Seat.usable_count - reserved_seats
  end
end
