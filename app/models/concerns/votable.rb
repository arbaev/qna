module Votable
  extend ActiveSupport::Concern

  included do
    has_many :votes, dependent: :destroy, as: :votable
  end

  def rating
    Vote.where('votable_id = :votable_id AND votable_type = :votable_type',
               votable_id: id, votable_type: self.class.name).sum(:value)
  end
end
