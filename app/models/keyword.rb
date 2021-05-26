# == Schema Information
#
# Table name: keywords
#
#  id   :bigint           not null, primary key
#  term :string(50)       not null
#
class Keyword < ApplicationRecord
  # Associations
  has_and_belongs_to_many :stalls, touch: true # touch - associated record's updated time is changed when keyword is change.
end
