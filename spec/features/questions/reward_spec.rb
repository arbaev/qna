require 'rails_helper'

feature 'User can add reward to question', %q{
  In order to provide motivation for answering my question
  As an question's author
  I'd like to be able to add reward
} do

  given(:user) { create(:user) }
  given(:question) { create(:question, author: user) }
  # given(:reward) { create(:reward, question: question) }

  describe 'When create question' do
    background do
      sign_in(user)
      visit new_question_path
      fill_in 'Your question', with: 'Test question'
      fill_in 'Description of the question', with: 'text text text'
    end

    scenario 'author add reward' do
      fill_in 'Reward name', with: 'reward.name'
      attach_file 'Reward image', "#{Rails.root}/spec/rails_helper.rb"

      click_on 'Create Question'

      expect(page).to have_content 'reward.name'
      expect(page).to have_css("img[src*='rails_helper.rb']")
    end

    scenario 'tries to add reward with empty name' do
      attach_file 'Reward image', "#{Rails.root}/spec/rails_helper.rb"

      click_on 'Create Question'

      expect(page).to_not have_css("img[src*='rails_helper.rb']")
      expect(page).to have_content "Reward name can't be blank"
      expect(page).to have_content 'please, enter valid data'
    end

    scenario 'tries to add reward without file' do
      fill_in 'Reward name', with: 'reward.name'
      click_on 'Create Question'

      expect(page).to_not have_css("img[src*='rails_helper.rb']")
      expect(page).to have_content 'Reward image must be added'
      expect(page).to have_content 'please, enter valid data'
    end

    scenario 'tries to add invalid file of reward'

  end

  describe 'When edit question', js: true do
    background do
      sign_in(user)
      visit question_path(question)
      click_on 'Edit'
    end

    scenario 'author add reward'
    scenario 'tries to add reward with empty name'
    scenario 'tries to add reward without file'
    scenario 'tries to add invalid file of reward'

  end
end
