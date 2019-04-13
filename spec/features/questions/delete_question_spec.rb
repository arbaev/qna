require 'rails_helper'

feature 'user can delete his question', %q{
  user must be logged in
  user must be an author of question
} do

  given(:user1) { create(:user) }
  given(:question_user1) { create(:question, author_id: user1.id) }
  given(:user2) { create(:user) }
  given(:question_user2) { create(:question, author_id: user2.id) }

  describe 'Authenticated user' do
    background do
      sign_in(user1)
    end

    scenario 'user tries to delete his question' do
      visit question_path(question_user1)
      click_on 'delete'

      expect(page).to have_content 'question successfully deleted'
      expect(page).to_not have_content question_user1.title
    end

    scenario 'user tries to delete someone else question' do
      visit question_path(question_user2)

      expect(page).not_to have_link('delete')
    end
  end

  scenario 'Unauthenticated user tries to delete question' do
    visit question_path(question_user1)

    expect(page).not_to have_link('delete')
  end
end
