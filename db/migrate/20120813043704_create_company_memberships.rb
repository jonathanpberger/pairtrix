class CreateCompanyMemberships < ActiveRecord::Migration
  def change
    create_table :company_memberships do |t|
      t.integer :company_id
      t.integer :user_id
      t.string :role

      t.timestamps
    end

    add_index(:company_memberships, [:company_id, :user_id])
    add_index(:company_memberships, :role)
  end
end
