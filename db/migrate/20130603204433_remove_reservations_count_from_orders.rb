class RemoveReservationsCountFromOrders < ActiveRecord::Migration
  def up
    remove_column :orders, :reservations_count
  end

  def down
    add_column :orders, :reservations_count, :integer, :default => 0, :null => false
  end
end
