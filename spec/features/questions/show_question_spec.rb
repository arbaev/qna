require 'rails_helper'

feature 'user can view the question', %q{
  the user can view the question,
  view the answers to the question,
  create a new answer to the question
} do

  given!(:question) { create(:question, id: 9999) }
  given!(:answers) { create_list(:answers_list, 3, question: question) }

  background { visit question_path(question) }

  scenario 'the user can view the question' do
    expect(page).to have_content("#{question.title}")
    expect(page).to have_content("#{question.body}")
  end

  scenario 'view the answers to the question' do
    answers.each do |answer|
      expect(page).to have_content answer.body
    end
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
