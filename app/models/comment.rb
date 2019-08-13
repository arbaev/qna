class Comment < ApplicationRecord
  belongs_to :commentable, polymorphic: true, touch: true
  belongs_to :author, class_name: 'User'

  validates :body, presence: true
  validates :commentable_type, inclusion: %w[Question Answer]
end
