class Admin::BaseController < ApplicationController
  before_action :authenticate_user!
  before_action :check_admin

  layout 'admin'

  private

  def check_admin
    unless current_user.admin?
      redirect_to root_path, danger: t('helpers.flash.not_admin')
    end
  end
end