class Answer < ApplicationRecord
  belongs_to :word
  validates :user_definition, presence: true
end
