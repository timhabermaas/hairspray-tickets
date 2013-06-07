class Gig < ActiveRecord::Base
  validates :title, :date, :presence => true

  has_many :orders

  def free_seats
    Seat.usable_count - reserved_seats_sum
  end

  def prev_gig
    Gig.where("date < ?", self.date).order("date desc").first
  end

  def next_gig
    Gig.where("date > ?", self.date).order("date").first
  end

  private
  def reserved_seats_sum
    orders.inject(0) { |sum, o| sum + o.seats.size }
  end
end
