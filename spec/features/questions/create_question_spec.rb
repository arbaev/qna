require 'rails_helper'

feature 'user can create question', %q{
  user go to new question form
  show question page
} do

  given(:user) { create(:user) }
  given(:question) { create(:question, author_id: user.id) }

  describe 'Authenticated user' do
    background do
      sign_in(user)
      visit questions_path
      click_on 'Ask question'
    end

    scenario 'user create question with correct data' do
      fill_in 'Title', with: question.title
      fill_in 'Body', with: question.body
      click_on 'Create question'

      expect(page).to have_content 'question successfully created'
      expect(page).to have_content question.title
      expect(page).to have_content question.body
    end

    scenario 'user create question without data' do
      click_on 'Create question'

      expect(page).to have_content('please, enter valid data')
    end
  end

  scenario 'Unauthenticated user cannot ask a question' do
    visit questions_path
    click_on 'Ask question'

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end
end
