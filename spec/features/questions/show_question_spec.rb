require 'rails_helper'

feature 'user can view the question', %q{
  the user can view the question,
  view the answers to the question,
  create a new answer to the question
} do

  given!(:question) { create(:question, id: 9999) }

  scenario 'the user can view the question' do
    visit question_path(question)
    expect(page).to have_content("#{question.title}")
    expect(page).to have_content("#{question.body}")
  end

  scenario 'view the answers to the question,'
  scenario 'create a new answer to the question'
end
