class DescriptionsController < ApplicationController
  skip_before_action :authenticate_user!
  skip_before_action :profile_check

  def show; end
end
