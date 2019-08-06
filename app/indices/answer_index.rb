ThinkingSphinx::Index.define :answer, with: :active_record do
  indexes body
  indexes author.email, as: :user, soratble: true

  has author_id, created_at, updated_at
end
