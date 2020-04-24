class CreateWireguardNetworks < ActiveRecord::Migration[6.0]
  def change
    create_table :wireguard_networks do |t|
      t.string :ip_address, null: false
      t.string :host, null: false
      t.references :key, null: false

      t.timestamps
    end
  end
end
