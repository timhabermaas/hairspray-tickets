class AddGigIdToReservations < ActiveRecord::Migration
  def up
    add_column :reservations, :gig_id, :integer, :null => false, :default => 0
    change_column_default :reservations, :gig_id, nil
  end

  def down
    remove_column :reservations, :gig_id
  end
end
