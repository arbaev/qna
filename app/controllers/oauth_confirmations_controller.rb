class OauthConfirmationsController < ApplicationController
  def new; end

  def create
    @email = oauth_confirmation_params[:email]
  end

  private

  def oauth_confirmation_params
    params.permit(:email)
  end
end
