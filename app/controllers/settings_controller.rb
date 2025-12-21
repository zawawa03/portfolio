class SettingsController < ApplicationController
  skip_before_action :authenticate_user!
  skip_before_action :profile_check

  def show; end

  def agreement; end

  def plivacy_policy; end
end
