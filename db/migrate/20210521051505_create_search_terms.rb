class CreateSearchTerms < ActiveRecord::Migration[6.1]
  def change
    create_table :search_terms do |t|
      t.string :term, limit: 50
      t.references :stall, null: false, foreign_key: true
    end
  end
end
