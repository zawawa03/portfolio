class BoardsController < ApplicationController
  before_action :set_room_option, only: %i[new create]
  skip_before_action :authenticate_user!, only: %i[index show]

  def index
    @boards = Board.includes(:creator).order(created_at: :DESC).page(params[:page]).per(10)
  end

  def show
    @board = Board.find(params[:id])
    @comments = @board.comments.where(parent_id: nil).order(created_at: :ASC).page(params[:page]).per(20)
    @number = 0
    @comment = Comment.new
  end

  def new
    @board = Board.new
  end

  def create
    @board = current_user.boards.build(board_params)
    if @board.save
      redirect_to boards_path, success: t(".create")
    else
      flash.now[:danger] = t(".not_create")
      render :new, status: :unprocessable_entity
    end
  end

  private

  def board_params
    params.require(:board).permit(:title, :game_id, tag_ids: [])
  end

  def set_room_option
    @game_options = Game.game_option
    @board_tag_options = Tag.search(3)
  end
end
