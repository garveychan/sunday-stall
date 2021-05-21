class CreateSearchTerms < ActiveRecord::Migration[6.1]
  def change
    create_table :keywords do |t|
      t.string :term, limit: 50
    end

    create_table :search_terms, id: false do |t|
      t.belongs_to :stall, null: false, foreign_key: true
      t.belongs_to :keywords, null: false, foreign_key: true
    end
  end
end