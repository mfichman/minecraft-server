class CreateMinecraftJars < ActiveRecord::Migration[6.0]
  def change
    create_table :minecraft_jars do |t|
      t.string :version, null: false
      t.string :url, null: false

      t.index :version, unique: true

      t.timestamps
    end
  end
end
