require 'rails_helper'

feature 'guest can view answers to the question', %q{
  user can be unauthenticate
} do

  given!(:question) { create(:question, id: 9999) }
  given!(:answers) { create_list(:answers_list, 3, question: question) }

  background { visit question_path(question) }

  scenario 'view the answers to the question' do
    answers.each do |answer|
      expect(page).to have_content answer.body
    end
  end
end
