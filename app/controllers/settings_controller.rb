class SettingsController < ApplicationController
  skip_before_action :authenticate_user!
  def show
    @user = current_user
  end
end
