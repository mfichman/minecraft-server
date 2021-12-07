class AddMinecraftModderToMinecraftServers < ActiveRecord::Migration[6.0]
  def change
    add_reference :minecraft_servers, :modder, index: true
  end
end
