class AddPathToMinecraftMods < ActiveRecord::Migration[7.0]
  def change
    add_column :minecraft_mods, :path, :string, default: 'mods/', null: false
  end
end
