class BoardsController < ApplicationController
  before_action :set_room_option, only: %i[index search new create]
  skip_before_action :authenticate_user!, only: %i[index show search]
  skip_before_action :profile_check, only: %i[index show search]

  def index
    @boards = Board.includes(:creator).order(created_at: :DESC).page(params[:page]).per(10)
  end

  def show
    @board = Board.find(params[:id])
    @comments = @board.comments.where(parent_id: nil).order(created_at: :ASC).page(params[:page]).per(20)
    @number = 0
    @comment = Comment.new
    set_meta_tags(
      title: @board.title,
      description: "掲示板をチェック！",
      og: {
        title: @board.title,
        description: "掲示板をチェック！",
        url: board_path(@board),
        image: url_for(@board.game.picture)
      },
      twitter: {
        title: @board.title,
        description: "掲示板をチェック！",
        url: board_path(@board),
        image: url_for(@board.game.picture)
      }
    )
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

  def destroy
    @board = Board.find(params[:id])
    if @board.destroy
      redirect_to boards_path, success: t(".destroy")
    else
      redirect_to boards_path, danger: t(".not_destroy")
    end
  end

  def search
    @board_search = BoardSearchForm.new(search_params)
    @boards = @board_search.result.page(params[:page]).per(10)
  end

  private

  def board_params
    params.require(:board).permit(:title, :game_id, tag_ids: [])
  end

  def set_room_option
    @game_options = Game.game_option
    @board_tag_options = Tag.search(3)
  end

  def search_params
    params.require(:q).permit(:word, :tag_id)
  end
end
