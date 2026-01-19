class DescriptionsController < ApplicationController
  skip_before_action :authenticate_user!
  skip_before_action :profile_check

  def show
    begin
      raise "Rollbar test error"
    rescue => e
      Rollbar.error(e)
    end
  end
end
