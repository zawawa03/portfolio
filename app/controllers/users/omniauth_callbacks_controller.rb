# frozen_string_literal: true

class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  skip_before_action :verify_authenticity_token, only: :google_oauth2
  # You should configure your model like this:
  # devise :omniauthable, omniauth_providers: [:twitter]

  # You should also create an action method in this controller like this:
  # def twitter
  # end

  # More info at:
  # https://github.com/heartcombo/devise#omniauth

  # GET|POST /resource/auth/twitter
  # def passthru
  #   super
  # end

  def google_oauth2
    callback_for(:google_oauth2)
  end

  def callback_for(provider)
    @user = User.from_omniauth(request.env['omniauth.auth'])
    if @user.persisted?
        sign_in_and_redirect @user, event: :authentication
        set_flash_message(:success, :success, kind: provider.to_s.capitalize) if is_navigational_format?
    else
      session["devise.#{provider}_data"] = request.env['omniauth.auth'].except(:extra)
      redirect_to new_user_session_path
    end
  end

  # GET|POST /users/auth/twitter/callback
  def failure
    redirect_to new_user_session_path, danger: t(".failure")
  end

  protected

  def after_sign_in_path_for(resource)
    if resource.profile.blank?
      new_profile_path
    else
      root_path
    end
  end
  # The path used when OmniAuth fails
  # def after_omniauth_failure_path_for(scope)
  #   super(scope)
  # end
end
