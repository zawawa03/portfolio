class Admin::BoardsController < Admin::BaseController
  def index
    @boards = Board.includes(:creator).order(created_at: :DESC)
  end

  def show
    @board = Board.find(params[:id])
    @comments = @board.comments
  end

  def destroy
    @board = Board.find(params[:id])
    if @board.destroy
      redirect_to admin_boards_path, success: t(".destroy")
    else
      flash.now[:danger] = t(".not_destroy")
      render :index, status: :unprocessable_entity
    end
  end

  def search
    @search_board = AdminBoardSearchForm.new(search_params)
    @boards = @search_board.result
  end

  private

  def search_params
    params.require(:q).permit(:title, :game, :sort)
  end
end
