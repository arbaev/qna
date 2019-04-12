require 'rails_helper'

feature 'user can view the question', %q{
  the user can view the question,
  view the answers to the question,
  create a new answer to the question
} do

  given(:user) { create(:user) }
  given!(:question) { create(:question, id: 9999, author_id: user.id) }
  given!(:answers) { create_list(:answers_list, 3, question: question, author_id: user.id) }

  background { visit question_path(question) }

  scenario 'the user can view the question' do
    expect(page).to have_content("#{question.title}")
    expect(page).to have_content("#{question.body}")
  end
end
