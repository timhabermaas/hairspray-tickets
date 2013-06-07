class Reservation < ActiveRecord::Base
  belongs_to :seat
  belongs_to :order

  validates_presence_of :order_id, :seat_id, :gig_id

  before_validation :set_gig_id

  private
  def set_gig_id
    self.gig_id = order.gig_id unless order.nil?
  end
end
