class CreateUsers < ActiveRecord::Migration[6.1]
  def change
    create_table :users do |t|
      t.string :first_name, limit: 50, null: false
      t.string :last_name, limit: 50, null: false
      t.date :date_of_birth, null: false
      t.string :phone_number, limit: 12, null: false

      t.timestamps
    end
  end
end