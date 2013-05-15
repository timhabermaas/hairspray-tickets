class Order < ActiveRecord::Base
  validates :name, :presence => true
  validates :reduced_count, :numericality => { :only_integer => true, :greater_than_or_equal_to => 0 }
  validate :has_not_more_reduced_seats_than_seats

  belongs_to :gig
  has_many :reservations
  has_many :seats, :through => :reservations

  def paid?
    not paid_at.nil?
  end

  def seats_count
    reservations_count
  end

  private
  def has_not_more_reduced_seats_than_seats
    errors.add :reduced_count, "can't exceed total number of seats" if reduced_count > seats.size
  end
end
