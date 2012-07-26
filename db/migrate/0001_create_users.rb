class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :provider
      t.string :uid
      t.string :name
      t.string :email
      t.boolean :admin, default: false

      t.timestamps
    end

    add_index(:users, :uid)
    add_index(:users, :email)
  end
end
