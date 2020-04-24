class CreateMinecraftCommands < ActiveRecord::Migration[6.0]
  def change
    create_table :minecraft_commands do |t|
      t.references :server, null: false, foreign_key: true, index: true
      t.string :text, null: false

      t.timestamps
    end
  end
end
