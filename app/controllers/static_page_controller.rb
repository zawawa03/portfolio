class StaticPageController < ApplicationController
  skip_before_action :authenticate_user!
  before_action :set_latest_content
  def top; end

  private

  def set_latest_content
    @top_page_rooms = Room.includes(:creator).where(category: 0).limit(10).order(created_at: :DESC)
    @top_page_boards = Board.includes(:creator).limit(10).order(created_at: :DESC)
  end
end
