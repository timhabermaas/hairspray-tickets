class AddReservationsCountToOrder < ActiveRecord::Migration
  def change
    add_column :orders, :reservations_count, :integer, :default => 0, :null => false
  end
end
