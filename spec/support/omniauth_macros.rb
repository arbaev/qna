# frozen_string_literal: true

module OmniauthMacros
  def mock_auth_github
    OmniAuth.config.mock_auth[:github] = OmniAuth::AuthHash.new(
      provider: 'github',
      uid: '51515',
      info: OmniAuth::AuthHash::InfoHash.new(
        nickname: 'github_mockuser',
        email: 'github_mockuser@mail.ru'
      )
    )
  end

  def mock_auth_mail_ru
    OmniAuth.config.mock_auth[:mail_ru] = OmniAuth::AuthHash.new(
      provider: 'mail_ru',
      uid: '35478',
      info: OmniAuth::AuthHash::InfoHash.new(
        nickname: 'mailru_mockuser',
        email: 'mailru_mockuser@mail.ru'
      )
    )
  end

  def mock_auth_vkontakte
    OmniAuth.config.mock_auth[:vkontakte] = OmniAuth::AuthHash.new(
      provider: 'vkontakte',
      uid: '989898',
      info: OmniAuth::AuthHash::InfoHash.new(email: nil)
    )
  end
end
