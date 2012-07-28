class CreatePairingDays < ActiveRecord::Migration
  def change
    create_table :pairing_days do |t|
      t.integer :team_id
      t.date :pairing_date

      t.timestamps
    end

    add_index(:pairing_days, :team_id)
    add_index(:pairing_days, :pairing_date, order: { pairing_date: :desc })
  end
end
