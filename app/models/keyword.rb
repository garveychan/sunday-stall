# == Schema Information
#
# Table name: keywords
#
#  id   :bigint           not null, primary key
#  term :string(50)
#
class Keyword < ApplicationRecord
  has_and_belongs_to_many :stalls
end
