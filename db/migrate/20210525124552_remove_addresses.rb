class RemoveAddresses < ActiveRecord::Migration[6.1]
  def change
    drop_table :addresses do |t|
      t.references :user, null: false, foreign_key: true
      t.integer :unit_num
      t.integer :street_num
      t.string :street_name, limit: 50
      t.string :city_name, limit: 50
      t.string :state_name, limit: 50
      t.integer :post_code
      t.string :country_name, limit: 50
    end
  end
end
