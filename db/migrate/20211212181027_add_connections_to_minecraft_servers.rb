class AddConnectionsToMinecraftServers < ActiveRecord::Migration[6.1]
  def change
    add_column :minecraft_servers, :connections, :bigint, default: 0, null: false
    add_column :minecraft_servers, :last_active_at, :datetime
  end
end
