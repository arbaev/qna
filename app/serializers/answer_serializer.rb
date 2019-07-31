class AnswerSerializer < ActiveModel::Serializer
  attributes :id, :body, :created_at, :updated_at, :author_id
  has_many :comments
  has_many :links
  has_many :files, serializer: AttachmentSerializer
  belongs_to :author, class: :user
end
