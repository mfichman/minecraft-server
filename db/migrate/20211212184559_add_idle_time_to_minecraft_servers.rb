class AddIdleTimeToMinecraftServers < ActiveRecord::Migration[6.1]
  def change
    add_column :minecraft_servers, :max_idle_time, :string
  end
end
