class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern
  before_action :authenticate_user!
  before_action :unchecked_notifications
  before_action :profile_check
  add_flash_types :success, :danger

  private
  def authenticate_user!(*args)
    unless user_signed_in?
      store_location_for(:user, request.fullpath)
      redirect_to new_user_session_path, danger: t("devise.failure.unauthenticated")
    end
  end

  def unchecked_notifications
    if user_signed_in?
      Notification.delete_from_blocked_user(current_user)
      @not_checked = current_user.receive_notifications.where(checked: false)
      @notifications_count = @not_checked.size
    end
  end

  def profile_check
    unless current_user.profile.present?
      redirect_to new_profile_path, success: t("helpers.flash.not_profile")
    end
  end
end
