class Gig < ActiveRecord::Base
  validates :title, :date, :presence => true

  has_many :orders

  def reserved_seats
    orders.inject(0) { |sum, o|  sum + o.seats.size }
  end

  def free_seats
    Seat.usable_count - reserved_seats
  end

  def prev_gig
    Gig.where("date < ?", self.date).order("date desc").first
  end

  def next_gig
    Gig.where("date > ?", self.date).order("date").first
  end
end
