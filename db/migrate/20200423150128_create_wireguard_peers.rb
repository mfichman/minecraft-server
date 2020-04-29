class CreateWireguardPeers < ActiveRecord::Migration[6.0]
  def change
    create_table :wireguard_peers do |t|
      t.string :name, null: false, unique: true, index: true
      t.string :ip_address, null: false
      t.references :network, null: false, index: true
      t.references :key, null: false, index: true

      t.index [:ip_address, :network_id], unique: true

      t.timestamps
    end
  end
end
