require 'rails_helper'

feature 'user can create question', %q{
  user go to new question form
  show question page
} do

  given(:user) { create(:user) }
  given(:question) { create(:question, author: user) }

  describe 'Authenticated user' do
    background do
      sign_in(user)
      visit questions_path
      click_on 'Ask question'
    end

    scenario 'user create question with correct data' do
      fill_in 'Your question', with: question.title
      fill_in 'Description of the question', with: question.body
      click_on 'Create Question'

      expect(page).to have_content 'question successfully created'
      expect(page).to have_content question.title
      expect(page).to have_content question.body
    end

    scenario 'user create question without data' do
      click_on 'Create Question'

      expect(page).to have_content 'please, enter valid data'
    end

    scenario 'user create question with attachment' do
      fill_in 'Your question', with: question.title
      fill_in 'Description of the question', with: question.body
      attach_file 'Attach file', ["#{Rails.root}/spec/rails_helper.rb","#{Rails.root}/spec/spec_helper.rb"]
      click_on 'Create Question'

      expect(page).to have_link 'rails_helper.rb'
      expect(page).to have_link 'spec_helper.rb'
    end
  end

  scenario 'Unauthenticated user cannot ask a question' do
    visit questions_path
    click_on 'Ask question'

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end
end
