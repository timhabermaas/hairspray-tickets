class Seat < ActiveRecord::Base
  attr_accessible :number, :row_id, :x, :row

  scope :usable, -> { where(:usable => true) }

  belongs_to :row

  def self.usable_count
    usable.count
  end
end
