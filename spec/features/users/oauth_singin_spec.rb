require 'rails_helper'

feature 'User can sign in via OAuth providers:' do

  background { visit new_user_session_path }

  context 'GitHub account' do
    scenario 'with correct credentials' do
      mock_auth_github
      click_on 'Sign in with GitHub'

      expect(page).to have_content OmniAuth.config.mock_auth[:github].info.email
      expect(page).to have_content 'Successfully authenticated from Github account.'
    end

    scenario 'with invalid credentials' do
      OmniAuth.config.mock_auth[:github] = :invalid_credentials
      click_on 'Sign in with GitHub'

      expect(page).to have_content 'Could not authenticate you from GitHub because "Invalid credentials".'
    end
  end

  context 'MailRu account' do
    scenario 'with correct credentials' do
      mock_auth_mail_ru
      click_on 'Sign in with MailRu'

      expect(page).to have_content OmniAuth.config.mock_auth[:mail_ru].info.email
      expect(page).to have_content 'Successfully authenticated from MailRu account.'
    end

    scenario 'with invalid credentials' do
      OmniAuth.config.mock_auth[:mail_ru] = :invalid_credentials
      click_on 'Sign in with MailRu'

      expect(page).to have_content 'Could not authenticate you from MailRu because "Invalid credentials".'
    end
  end
end
