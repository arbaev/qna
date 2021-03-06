require 'rails_helper'

feature 'user can delete his answer', %q{
  user must be logged in
  user must be an author of answer
} do

  given(:user1) { create(:user) }
  given(:question_user1) { create(:question, author: user1) }
  given!(:answer_user1) { create(:answer, question: question_user1, author: user1) }
  given(:user2) { create(:user) }
  given!(:answer_user2) { create(:answer, question: question_user1, author: user2) }

  describe 'Authenticated user', js: true do
    background do
      sign_in(user1)
      visit question_path(question_user1)
    end

    scenario 'user tries to delete his answer' do
      element = first('li', text: user1.email)
      within(element) { click_on 'Delete' }
      page.driver.browser.switch_to.alert.accept

      expect(page).to have_content 'answer successfully deleted'
      expect(page).to_not have_content answer_user1.body
    end

    scenario 'user tries to delete someone else answer' do
      element = first('li', text: user2.email)

      expect(element).not_to have_link 'delete answer'
    end
  end

  scenario 'Unauthenticated user tries to delete his question' do
    visit question_path(question_user1)

    expect(page).not_to have_link 'delete answer'
  end
end
