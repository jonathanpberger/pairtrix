class CreateTeamMemberships < ActiveRecord::Migration
  def change
    create_table :team_memberships do |t|
      t.integer :team_id
      t.integer :employee_id
      t.date :start_date
      t.date :end_date

      t.timestamps
    end

    add_index(:team_memberships, :team_id)
    add_index(:team_memberships, :employee_id)
  end
end
