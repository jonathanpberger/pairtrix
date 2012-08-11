class CreateCompanies < ActiveRecord::Migration
  def change
    create_table :companies do |t|
      t.integer :user_id
      t.string :name
      t.timestamps
    end

    add_index(:companies, [:user_id, :name])
  end
end
