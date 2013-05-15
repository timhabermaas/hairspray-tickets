class Seat < ActiveRecord::Base
  scope :usable, -> { where(:usable => true) }

  belongs_to :row

  def self.usable_count
    usable.count
  end
end
