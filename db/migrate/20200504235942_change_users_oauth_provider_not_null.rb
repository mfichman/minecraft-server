class ChangeUsersOauthProviderNotNull < ActiveRecord::Migration[6.0]
  def change
    change_column_null :users, :oauth_provider, null: true
    change_column_null :users, :oauth_uid, null: true
  end
end
