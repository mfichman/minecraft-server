class AddMinecraftJarToMinecraftServer < ActiveRecord::Migration[6.0]
  def change
    add_reference :minecraft_servers, :jar, index: true
  end
end
