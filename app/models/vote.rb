class Vote < ApplicationRecord
  belongs_to :votable, polymorphic: true

  validates :value, presence: true, numericality: { only_integer: true }
  validates :votable_type, inclusion: ['Answer']
end
