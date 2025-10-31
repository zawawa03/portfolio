class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern
  before_action :authenticate_user!
  before_action :unchecked_notifications
  add_flash_types :success, :danger

  private

  def unchecked_notifications
    if user_signed_in?
      @not_checked = current_user.receive_notifications.where(checked: false)
      @notifications_count = @not_checked.size
    end
  end
end
