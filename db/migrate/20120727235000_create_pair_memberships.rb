class CreatePairMemberships < ActiveRecord::Migration
  def change
    create_table :pair_memberships do |t|
      t.integer :pair_id
      t.integer :team_membership_id

      t.timestamps
    end

    add_index(:pair_memberships, [:pair_id, :team_membership_id])
  end
end
