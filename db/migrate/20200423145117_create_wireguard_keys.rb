class CreateWireguardKeys < ActiveRecord::Migration[6.0]
  def change
    create_table :wireguard_keys do |t|
      t.string :private_key, null: false
      t.string :public_key, null: false

      t.timestamps
    end
  end
end
