class CreateMinecraftModders < ActiveRecord::Migration[6.0]
  def change
    create_table :minecraft_modders do |t|
      t.string :version, null: false
      t.string :name, null: false
      t.string :url, null: false

      t.index [:name, :version], unique: true

      t.timestamps
    end
  end
end
