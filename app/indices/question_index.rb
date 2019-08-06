ThinkingSphinx::Index.define :question, with: :active_record do
  #fields
  indexes title
  indexes body
  indexes author.email, as: :user

  # attributes
  has author_id, created_at, updated_at
end
