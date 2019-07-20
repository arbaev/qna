class OauthCallbacksController < Devise::OmniauthCallbacksController
  def github
    oauth(auth)
  end

  def mail_ru
    oauth(auth)
  end

  def vkontakte
    oauth(auth)
  end

  def oauth(auth)
    @user = User.find_for_oauth(auth)

    if @user&.confirmed?
      sign_in_and_redirect @user, event: :authentication
      set_flash_message(:notice, :success, kind: auth.provider.to_s.capitalize) if is_navigational_format?
    elsif @user
      session[:provider] = auth.provider
      session[:uid] = auth.uid
      redirect_to new_user_confirmation_path
    else
      redirect_to root_path, alert: 'Something went wrong'
    end
  end

  private

  def auth
    request.env['omniauth.auth']
  end
end
