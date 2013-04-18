class CreateGigs < ActiveRecord::Migration
  def change
    create_table :gigs do |t|
      t.string :title, :null => false
      t.datetime :date, :null => false

      t.timestamps
    end
  end
end
