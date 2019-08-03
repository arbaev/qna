require 'rails_helper'

feature 'User can subscribe to question', %q{
  In order to get answer from a community
  As an authenticated user
  I'd like to be able to get email notification of new answers for my question
} do

  given(:user) { create :user }
  given(:question) { create :question, author: user }
  given(:question2) { create :question }

  scenario 'Authenticated user with subscription', js: true do
    sign_in user
    visit question_path(question)

    expect(page).to_not have_content 'Subscribe to answers'
    expect(page).to have_content 'Unsubscribe from answers'

    click_on 'Unsubscribe from answers'

    expect(page).to have_content 'Subscribe to answers'
    expect(page).to_not have_content 'Unsubscribe from answers'
  end

  scenario 'Authenticated user without subscription', js: true do
    sign_in user
    visit question_path(question2)

    expect(page).to have_content 'Subscribe to answers'
    expect(page).to_not have_content 'Unsubscribe from answers'

    click_on 'Subscribe to answers'

    expect(page).to_not have_content 'Subscribe to answers'
    expect(page).to have_content 'Unsubscribe from answers'
  end

  scenario 'Unauthenticated user', js: true do
    visit question_path(question)

    expect(page).to_not have_content 'Subscribe to answers'
    expect(page).to_not have_content 'Unsubscribe from answers'
  end
end
