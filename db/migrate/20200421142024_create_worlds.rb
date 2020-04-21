class CreateWorlds < ActiveRecord::Migration[6.0]
  def change
    create_table :worlds do |t|
      t.string :name, null: false, index: true

      t.timestamps
    end
  end
end
