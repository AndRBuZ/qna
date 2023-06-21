class OauthCallbacksController < Devise::OmniauthCallbacksController
  before_action :set_user
  before_action :redirect_to_new_authorization, only: [:vkontakte]

  def github
    authorization(:github)
  end

  def vkontakte
    authorization(:vkontakte)
  end

  private

  def set_user
    @auth = request.env['omniauth.auth']
    @user = User.find_for_oauth(@auth)
  end

  def authorization(provider)
    if @user&.persisted?
      sign_in_and_redirect @user, event: :authentication
      set_flash_message(:notice, :success, kind: provider) if is_navigational_format?
    else
      redirect_to root_path, alert: 'Something went wrong'
    end
  end

  def redirect_to_new_authorization
    if @auth&.uid && !@user&.auth_confirmed?(@auth)
      redirect_to new_authorization_path(provider: @auth.provider, uid: @auth.uid)
    end
  end
end
