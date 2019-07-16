class OauthCallbacksController < Devise::OmniauthCallbacksController
  def github
    oauth('Github')
  end

  def mail_ru
    oauth('MailRu')
  end

  def vkontakte
    oauth('Vkontakte')
  end

  private

  def oauth(provider)
    auth = request.env['omniauth.auth']
    @user = User.find_for_oauth(auth)

    if @user&.persisted?
      sign_in_and_redirect @user, event: :authentication
      set_flash_message(:notice, :success, kind: provider) if is_navigational_format?
    elsif @user
      session[:provider] = auth.provider
      session[:uid] = auth.uid.to_s
      redirect_to new_oauth_confirmation_path
    else
      redirect_to root_path, alert: 'Something went wrong'
    end
  end
end
