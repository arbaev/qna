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

  context 'Vkontakte account (does not provide email)' do
    given(:user) { create(:user) }

    scenario 'with correct credentials' do
      mock_auth_vkontakte
      click_on 'Sign in with Vkontakte'

      fill_in 'Email', with: "1#{user.email}" # хак для уникализации имейла
      click_on 'Send email'

      expect(page).to have_content "Email confirmation instructions send to 1#{user.email}"

      open_email("1#{user.email}")
      current_email.click_link 'Confirm my account'

      expect(page).to have_content "Your email address has been successfully confirmed."
      expect(page).to have_content "1#{user.email}"
    end

    scenario 'with invalid credentials' do
      OmniAuth.config.mock_auth[:vkontakte] = :invalid_credentials
      click_on 'Sign in with Vkontakte'

      expect(page).to have_content 'Could not authenticate you from Vkontakte because "Invalid credentials".'
    end
  end
end
