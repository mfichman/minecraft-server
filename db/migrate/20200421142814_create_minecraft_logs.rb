class CreateMinecraftLogs < ActiveRecord::Migration[6.0]
  def change
    create_table :minecraft_logs do |t|
      t.references :server, null: false, foreign_key: true, index: true
      t.string :text, null: false

      t.timestamps
    end
  end
end
