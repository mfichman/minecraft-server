class AddPropertiesToMinecraftServers < ActiveRecord::Migration[6.1]
  def change
    add_column :minecraft_servers, :properties, :json, null: false, default: {}
  end
end
