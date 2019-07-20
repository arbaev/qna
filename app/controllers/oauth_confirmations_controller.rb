class OauthConfirmationsController < Devise::ConfirmationsController
  def new; end

  def create
    @email = oauth_confirmation_params[:email]
    session[:email] = @email
    password = Devise.friendly_token[0, 20]
    @user = User.new(email: @email, password: password, password_confirmation: password)

    if @user.valid?
      @user.send_confirmation_instructions
    else
      flash.now[:alert] = 'please, enter valid email'
      render :new
    end
  end

  private

  def oauth_confirmation_params
    params.permit(:email)
  end

  def after_confirmation_path_for(_resource_name, resource)
    oauth_callbacks = OauthCallbacksController.new
    oauth_callbacks.request = request
    oauth_callbacks.response = response
    oauth_callbacks.oauth(auth)
  end

  def auth
    OmniAuth::AuthHash.new(
      provider: session[:provider],
      uid: session[:uid],
      info: OmniAuth::AuthHash::InfoHash.new(
        email: session[:email]
      )
    )
  end
end
