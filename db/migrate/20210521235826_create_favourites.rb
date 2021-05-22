class CreateFavourites < ActiveRecord::Migration[6.1]
  def change
    create_table :favourites do |t|
      t.references :user, null: false, foreign_key: true
      t.references :favouriteable, polymorphic: true, null: false
      t.timestamps
    end
  end
end
