class CreateJoinTableMinecraftModsServers < ActiveRecord::Migration[6.0]
  def change
    create_join_table :mods, :servers, table_name: :minecraft_mods_servers do |t|
      t.index [:server_id, :mod_id]
    end
  end
end
