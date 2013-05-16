class CreateSessions < ActiveRecord::Migration
  def change
    create_table :sessions do |t|
      t.string :key, :null => false

      t.timestamps
    end
  end
end
