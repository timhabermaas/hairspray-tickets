class AddUsableToSeat < ActiveRecord::Migration
  def change
    add_column :seats, :usable, :boolean, :null => false, :default => true
  end
end
