# == Schema Information
#
# Table name: keywords
#
#  id   :bigint           not null, primary key
#  term :string(50)       not null
#
class Keyword < ApplicationRecord
  has_and_belongs_to_many :stalls, touch: true

  validates_presence_of :term
end
