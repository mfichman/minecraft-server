class CreateMinecraftWorlds < ActiveRecord::Migration[6.0]
  def change
    create_table :minecraft_worlds do |t|
      t.string :name, null: false, index: true

      t.timestamps
    end
  end
end
