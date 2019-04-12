require 'rails_helper'

feature 'user can list questions', %q{
  user go to question index page
  user get list of all questions
} do

  given(:user) { create(:user) }
  given!(:questions) { create_list(:questions_list, 3, author_id: user.id) }

  scenario 'user get list of all questions' do
    visit questions_path

    questions.each do |q|
      expect(page).to have_content q.title
      expect(page).to have_content q.author.email
    end
  end
end
