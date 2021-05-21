# == Schema Information
#
# Table name: search_terms
#
#  id       :bigint           not null, primary key
#  term     :string(50)
#  stall_id :bigint           not null
#
# Indexes
#
#  index_search_terms_on_stall_id  (stall_id)
#
# Foreign Keys
#
#  fk_rails_...  (stall_id => stalls.id)
#
class SearchTerm < ApplicationRecord
  belongs_to :stall
end
