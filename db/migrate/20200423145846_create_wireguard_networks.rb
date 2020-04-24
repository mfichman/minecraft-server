class CreateWireguardNetworks < ActiveRecord::Migration[6.0]
  def change
    create_table :wireguard_networks do |t|
      t.string :ip_address, null: false
      t.references :key, null: false, foreign_key: true

      t.timestamps
    end
  end
end
