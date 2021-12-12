class AddOpsToMinecraftServers < ActiveRecord::Migration[6.1]
  def change
    add_column :minecraft_servers, :ops, :json, array: true, default: [], null: false
  end
end
