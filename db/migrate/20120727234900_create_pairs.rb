class CreatePairs < ActiveRecord::Migration
  def change
    create_table :pairs do |t|
      t.integer :pairing_day_id
      t.timestamps
    end

    add_index(:pairs, :pairing_day_id)
  end
end
