class User < ApplicationRecord
  devise :database_authenticatable,
         :registerable,
         :recoverable,
         :rememberable,
         :validatable

  has_many :questions, foreign_key: 'author_id', dependent: :nullify
  has_many :answers, foreign_key: 'author_id', dependent: :nullify
end
