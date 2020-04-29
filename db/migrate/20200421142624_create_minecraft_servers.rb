class CreateMinecraftServers < ActiveRecord::Migration[6.0]
  def change
    create_table :minecraft_servers do |t|
      t.string :host, null: false, unique: true, index: true
      t.references :backup, null: true, index: true

      t.timestamps
    end
  end
end
