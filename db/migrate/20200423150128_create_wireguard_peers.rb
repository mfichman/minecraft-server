class CreateWireguardPeers < ActiveRecord::Migration[6.0]
  def change
    create_table :wireguard_peers do |t|
      t.string :ip_address, null: false
      t.references :network, null: false, foreign_key: true
      t.references :key, null: false, foreign_key: true

      t.timestamps
    end
  end
end
