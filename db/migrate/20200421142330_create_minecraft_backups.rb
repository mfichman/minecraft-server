class CreateMinecraftBackups < ActiveRecord::Migration[6.0]
  def change
    create_table :minecraft_backups do |t|
      t.references :world, null: false, index: true
      t.boolean :autosave, null: false, default: false

      t.timestamps
    end
  end
end
