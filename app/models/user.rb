class User < ApplicationRecord
  devise :database_authenticatable,
         :registerable,
         :recoverable,
         :rememberable,
         :validatable

  has_many :questions, foreign_key: 'author_id', dependent: :destroy
  has_many :answers, foreign_key: 'author_id', dependent: :destroy
  has_many :rewards, dependent: :destroy
  has_many :votes, dependent: :destroy

  def author_of?(resource)
    resource.author_id == id
  end
end
