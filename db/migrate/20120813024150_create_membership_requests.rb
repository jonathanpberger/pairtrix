class CreateMembershipRequests < ActiveRecord::Migration
  def change
    create_table :membership_requests do |t|
      t.integer :company_id
      t.integer :user_id
      t.string :status

      t.timestamps
    end

    add_index(:membership_requests, [:company_id, :user_id])
    add_index(:membership_requests, :status)
  end
end
