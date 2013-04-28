class Seat < ActiveRecord::Base
  attr_accessible :number, :row_id, :x, :row

  belongs_to :row

  def self.usuable_count
    count
  end
end
