class CreateUsers < ActiveRecord::Migration[6.1]
  def change
    create_table :users do |t|
      t.string :first_name, limit: 50
      t.string :last_name, limit: 50
      t.date :date_of_birth
      t.string :phone_number, limit: 12

      t.timestamps
    end
  end
end