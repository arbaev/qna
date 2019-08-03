class Question < ApplicationRecord
  include Votable
  include Commentable

  belongs_to :author, class_name: 'User'
  has_many :answers, dependent: :destroy
  has_many :links, dependent: :destroy, as: :linkable
  has_one :reward, dependent: :destroy
  has_many :subscriptions, dependent: :destroy

  accepts_nested_attributes_for :links, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :reward, reject_if: :all_blank, allow_destroy: true

  has_many_attached :files

  validates :title, :body, presence: true

  after_create :subscribe_to_answers

  def set_reward!(author)
    reward&.update!(user: author)
  end

  private

  def subscribe_to_answers
    subscriptions.create(user: author)
  end
end
