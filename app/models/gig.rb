class Gig < ActiveRecord::Base
  attr_accessible :title, :date

  validates :title, :date, :presence => true

  has_many :orders

  def reserved_seats
    orders.inject(0) { |sum, o|  sum + o.seats_count }
  end

  def free_seats
    Seat.usuable_count - reserved_seats
  end
end
