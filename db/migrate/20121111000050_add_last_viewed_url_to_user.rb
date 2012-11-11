class AddLastViewedUrlToUser < ActiveRecord::Migration
  def change
    add_column :users, :last_viewed_url, :string
    add_column :users, :sign_in_redirect_option, :string, default: 'dashboard'
  end
end
