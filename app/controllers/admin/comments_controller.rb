class Admin::CommentsController < Admin::BaseController
  def destroy
    @comment = Comment.find(params[:id])
    @board = Board.find(params[:board_id])
    if @comment.destroy
      redirect_to admin_board_path(@board), success: t(".destroy")
    else
      redirect_to admin_board_path(@board), danger: t(".not_destroy")
    end
  end
end
