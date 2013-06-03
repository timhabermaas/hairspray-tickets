class Order < ActiveRecord::Base
  validates :name, :gig_id, :presence => true
  validates :reduced_count, :numericality => { :only_integer => true, :greater_than_or_equal_to => 0 }
  validate :has_not_more_reduced_seats_than_seats
  validate :has_at_least_one_seat

  belongs_to :gig
  has_many :reservations
  has_many :seats, :through => :reservations

  def paid?
    not paid_at.nil?
  end

  def pay!
    self.paid_at = DateTime.now
    save
  end

  def unpay!
    self.paid_at = nil
    save
  end

  # TODO extract configuration
  def costs(full_cost = 15, reduced_cost = 12)
    (seats.size - reduced_count) * full_cost + reduced_count * reduced_cost
  end

  private
  def has_not_more_reduced_seats_than_seats
    errors.add :reduced_count, "can't exceed total number of seats" if reduced_count > seats.size
  end

  def has_at_least_one_seat
    errors.add :seats, "must be at least one" if seats.size < 1
  end
end
