class Order < ActiveRecord::Base
  attr_accessible :name, :paid_at, :reduced_count, :gig, :seats

  validates :name, :presence => true
  validate :has_not_more_reduced_seats_than_seats

  belongs_to :gig
  has_many :reservations
  has_many :seats, :through => :reservations

  private
  def has_not_more_reduced_seats_than_seats
    errors.add :reduced_count, "can't exceed total number of seats" if reduced_count > seats.size
  end
end
