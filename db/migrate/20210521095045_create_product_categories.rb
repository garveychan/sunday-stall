class CreateProductCategories < ActiveRecord::Migration[6.1]
  def change
    create_table :product_categories do |t|
      t.string :name, limit: 50
    end
    
    add_reference :products, :product_category, null: false, foreign_key: true
  end
end