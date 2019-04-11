require 'rails_helper'

feature 'user can create answer to the question', %q{
  user must be authenticate,
  create a new answer to the question
} do

  given!(:question) { create(:question, id: 9999) }
  given!(:answers) { create_list(:answers_list, 3, question: question) }
  given(:user) { create(:user) }

  describe 'Authenticated user' do
    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'create a new answer to the question' do
      fill_in 'Body', with: answers.first.body
      click_on 'Create answer'
      expect(page).to have_content('answer successfully created')
    end

    scenario 'create empty answer' do
      fill_in 'Body', with: nil
      click_on 'Create answer'
      expect(page).to have_content("please, enter answer's text")
    end
  end

  scenario 'unAuth user cannot create answer' do
    visit question_path(question)
    click_on 'Create answer'

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end
end
