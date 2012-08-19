class AddHashKeyToMembershipRequests < ActiveRecord::Migration
  def change
    add_column :membership_requests, :hash_key, :string
    add_index :membership_requests, :hash_key
  end
end
