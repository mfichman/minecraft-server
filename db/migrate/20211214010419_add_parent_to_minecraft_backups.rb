class AddParentToMinecraftBackups < ActiveRecord::Migration[6.1]
  def change
    add_reference :minecraft_backups, :parent, index: true
  end
end
