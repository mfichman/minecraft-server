class CreateWorldBackups < ActiveRecord::Migration[6.0]
  def change
    create_table :world_backups do |t|
      t.references :world, null: false

      t.timestamps
    end
  end
end
