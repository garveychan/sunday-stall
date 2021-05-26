class CreateStalls < ActiveRecord::Migration[6.1]
  def change
    create_table :stalls do |t|
      t.string :title, limit: 50, null: false
      t.string :subtitle, limit: 100, null: false
      t.text :description, null: false
      t.boolean :active, null: false
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
