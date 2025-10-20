# frozen_string_literal: true

class Admin::SessionsController < Admin::BaseController
  # before_action :configure_sign_in_params, only: [:create]
  skip_before_action :authenticate_user!, only: %i[new create]
  before_action :check_admin, only: %i[destroy]

  layout "admin_login"

  # GET /resource/sign_in
  def new
    @user = User.new
  end
  # POST /resource/sign_in
  def create
    @user = User.find_by(email: params[:user][:email])
    if @user&.valid_password?(params[:user][:password])
      sign_in(@user)
      redirect_to admin_root_path, success: t("admin.flash.login")
    else
      @user = User.new(email: params[:user][:email])
      flash.now[:danger] = t("admin.flash.failed_login")
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    sign_out(current_user)
    redirect_to admin_login_path, success: t("admin.flash.logout")
  end
  # DELETE /resource/sign_out
  # def destroy
  #   super
  # end

  private
  # def configure_sign_in_params
  #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
  # end
end
