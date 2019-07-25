class User < ApplicationRecord
  devise :database_authenticatable,
         :registerable,
         :recoverable,
         :rememberable,
         :validatable,
         :confirmable,
         :omniauthable, omniauth_providers: [:github, :mail_ru, :vkontakte]

  has_many :questions, foreign_key: 'author_id', dependent: :destroy
  has_many :answers, foreign_key: 'author_id', dependent: :destroy
  has_many :rewards, dependent: :destroy
  has_many :votes, dependent: :destroy
  has_many :comments, foreign_key: 'author_id', dependent: :destroy
  has_many :authorizations, dependent: :destroy

  def self.find_for_oauth(auth)
    Services::FindForOauth.new(auth).call
  end

  def author_of?(resource)
    resource.author_id == id
  end

  def confirmation_required?
    false
  end
end
