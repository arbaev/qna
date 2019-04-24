require 'rails_helper'

feature 'user can edit his question', %q{
  user must be logged in
  edit question via ajax
  show question page
} do

  given(:user) { create(:user) }
  given(:question) { create(:question, author: user) }

  describe 'Authenticated user', js: true do
    background do
      sign_in(user)
      visit question_path(question)
      click_on 'Edit'
    end

    scenario 'edit question' do
      new_title = Faker::Number.hexadecimal(10)
      new_body = Faker::Number.hexadecimal(15)
      fill_in 'Your question', with: new_title
      fill_in 'Description of the question', with: new_body
      click_on 'Update Question'

      expect(page).to have_content new_title
      expect(page).to have_content new_body
      expect(page).to have_content 'question successfully edited'
    end

    scenario 'with invalid data' do
      fill_in 'Your question', with: ''
      fill_in 'Description of the question', with: ''
      click_on 'Update Question'

      expect(page).to have_content "Title can't be blank"
      expect(page).to have_content "Body can't be blank"
      expect(page).to have_content 'question editing failed'
    end

    scenario 'with no changes' do
      click_on 'Update Question'

      expect(page).to have_content question.title
      expect(page).to have_content question.body
    end

    scenario 'adding attachment' do
      attach_file 'Attach file', ["#{Rails.root}/spec/rails_helper.rb","#{Rails.root}/spec/spec_helper.rb"]
      click_on 'Update Question'

      expect(page).to have_link 'rails_helper.rb'
      expect(page).to have_link 'spec_helper.rb'
    end

    scenario 'deleting attached files' do
      attach_file 'Attach file', ["#{Rails.root}/spec/rails_helper.rb","#{Rails.root}/spec/spec_helper.rb"]
      click_on 'Update Question'

      first("a[data-method='delete']").click

      expect(page).to_not have_link 'rails_helper.rb'
    end
  end

  scenario 'Unauthenticated user cannot edit a question' do
    visit question_path(question)

    expect(page).not_to have_link 'Edit'
  end
end
