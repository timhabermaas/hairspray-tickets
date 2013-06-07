class Gig < ActiveRecord::Base
  validates :title, :date, :presence => true

  has_many :orders
  has_many :reservations

  def free_seats
    Seat.usable_count - reservations.size
  end
end
