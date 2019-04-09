require 'rails_helper'

feature 'user can create question', %q{
  user go to new question form
  show question page
} do

  given(:question) {create(:question)}

  background { visit new_question_path }

  scenario 'user create question with correct data' do
    fill_in 'Title', with: question.title
    fill_in 'Body', with: question.body
    click_on 'Create question'
    expect(page).to have_content('question successfully created')
  end

  scenario 'user create question without data' do
    click_on 'Create question'
    expect(page).to have_content('please, enter valid data')
  end
end
