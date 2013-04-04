class AddDoNotPairToEmployees < ActiveRecord::Migration
  def change
    add_column :employees, :do_not_pair, :boolean, default: false
  end
end
