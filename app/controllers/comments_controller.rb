class CommentsController < ApplicationController
  skip_before_action :authenticate_user!

  def create
    board = Board.find(params[:board_id])
    @comment = board.comments.build(comment_params)
    if @comment.save
      redirect_to board_path(board), success: t(".create")
    else
      redirect_to board_path(board), danger: t(".not_create")
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:user_id, :parent_id, :body, media: [])
  end
end
