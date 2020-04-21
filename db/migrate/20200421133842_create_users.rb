class CreateUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :users do |t|
      t.string :email, unique: true, index: true
      t.string :oauth_provider, null: false
      t.string :oauth_uid, null: false
      t.timestamps
    end
  end
end
