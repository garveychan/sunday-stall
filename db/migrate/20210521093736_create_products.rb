class CreateProducts < ActiveRecord::Migration[6.1]
  def change
    create_table :products do |t|
      t.string :name, limit: 50, null: false
      t.text :description, null: false
      t.integer :unit_price, null: false
      t.integer :stock_level, null: false
      t.boolean :active, null: false
      t.references :stall, null: false, foreign_key: true
      t.timestamps
    end
  end
end