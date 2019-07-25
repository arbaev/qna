class OauthCallbacksController < Devise::OmniauthCallbacksController
  before_action :oauth

  def github; end

  def mail_ru; end

  def vkontakte; end

  private

  def oauth
    auth = request.env['omniauth.auth']
    unless auth
      redirect_to new_user_session_path, alert: 'Authentication failed, please try again.'
      return
    end

    @user = User.find_for_oauth(auth)
    if @user&.confirmed?
      sign_in_and_redirect @user, event: :authentication
      set_flash_msg(auth)
    else
      session[:provider] = auth.provider
      session[:uid] = auth.uid
      redirect_to new_user_confirmation_path
    end
  end

  def set_flash_msg(auth)
    if is_navigational_format?
      set_flash_message(:notice, :success, kind: auth.provider.to_s.capitalize)
    end
  end
end
