require 'rails_helper'

feature 'User can edit his answer', %q{
  In order to correct mistakes
  As an author of answer
  I'd like ot be able to edit my answer
} do

  given!(:user) { create(:user) }
  given!(:question) { create(:question, author: user) }
  given!(:answer) { create(:answer, question: question, author: user) }

  scenario 'Unauthenticated can not edit answer' do
    visit question_path(question)

    expect(page).to_not have_link 'Edit'
  end

  describe 'Authenticated user', js: true do
    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'edits his answer' do
      within '.answers-list' do
        click_on 'Edit'
        text = Faker::Number.hexadecimal(10)
        fill_in 'Your answer', with: text
        click_on 'Update Answer'

        expect(page).to_not have_content answer.body
        expect(page).to have_content text
        expect(page).to_not have_selector 'input'
      end
    end

    scenario 'edits his answer with errors'
    scenario "tries to edit other user's question"
  end
end
