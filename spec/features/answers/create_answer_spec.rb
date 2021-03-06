require 'rails_helper'

feature 'user can create answer to the question', %q{
  user must be authenticate,
  create a new answer to the question
} do

  given(:user) { create(:user) }
  given!(:question) { create(:question, author: user) }
  given!(:question2) { create(:question) }

  describe 'Authenticated user', js: true do
    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'create a new answer to the question' do
      text = Faker::Number.hexadecimal(10)
      fill_in 'Your answer', with: text
      click_on 'Create Answer'

      expect(current_path).to eq question_path(question)
      expect(page).to have_content 'answer successfully created'
      within '.answers-list' do # чтобы убедиться, что ответ в списке, а не в форме
        expect(page).to_not have_content 'No answers yet'
        expect(page).to have_content text
      end
    end

    scenario 'create empty answer' do
      click_on 'Create Answer'

      expect(page).to have_content "please, enter text of answer"
      expect(page).to have_content "Body can't be blank"
    end

    scenario 'create answer with attachment' do
      text = Faker::Number.hexadecimal(10)
      within '#answer-form' do
        fill_in 'Your answer', with: text
        attach_file 'Attach files', ["#{Rails.root}/spec/rails_helper.rb","#{Rails.root}/spec/spec_helper.rb"]
        click_on 'Create Answer'
      end

      answer_block = find('.card-title', text: text).ancestor 'li'
      within answer_block do
        expect(page).to have_link 'rails_helper.rb'
        expect(page).to have_link 'spec_helper.rb'
      end
    end
  end

  describe 'ActionCable multiple sessions', js: true do
    scenario "answer appears on another user's question page" do
      text = Faker::Number.hexadecimal(10)

      Capybara.using_session('guest') do
        visit question_path(question)
      end

      Capybara.using_session('guest2') do
        visit question_path(question2)
      end

      Capybara.using_session('user') do
        sign_in(user)
        visit question_path(question)

        fill_in 'Your answer', with: text
        click_on 'Create Answer'

        expect(current_path).to eq question_path(question)
        expect(page).to have_content 'answer successfully created'

        # чтобы убедиться, что ответ в списке, а не в форме
        within '.answers-list' do
          expect(page).to_not have_content 'No answers yet'
          # чтобы убедиться, что ответ не задваивается из-за подписки на канал
          expect(page).to have_content text, count: 1
        end
      end

      Capybara.using_session('guest') do
        expect(page).to have_content text
      end

      Capybara.using_session('guest2') do
        expect(page).to_not have_content text
      end
    end
  end

  scenario 'unAuth user cannot create answer' do
    visit question_path(question)
    fill_in 'Your answer', with: 'just sample text'
    click_on 'Create Answer'

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end
end
