class AddCompanyIdToTeamsAndEmployees < ActiveRecord::Migration
  def up
    remove_index(:employees, [:last_name, :first_name])
    remove_index(:teams, :name)

    add_column :employees, :company_id, :integer
    add_column :teams, :company_id, :integer

    add_index(:employees, [:company_id, :last_name, :first_name])
    add_index(:teams, [:company_id, :name])
  end

  def down
    remove_index(:teams, [:company_id, :name])
    remove_index(:employees, [:company_id, :last_name, :first_name])

    remove_column :teams, :company_id
    remove_column :employees, :company_id

    add_index(:teams, :name)
    add_index(:employees, [:last_name, :first_name])
  end
end
