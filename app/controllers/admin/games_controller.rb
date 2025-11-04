class Admin::GamesController < Admin::BaseController
  def index
    @games = Game.all
    @game = Game.new
  end

  def create
    @games = Game.all
    @game = Game.new(game_params)
    if @game.save
      redirect_to admin_games_path, success: t(".create")
    else
      flash.now[:danger] = t(".not_create")
      render :index, status: :unprocessable_entity
    end
  end

  def destroy
    @game = Game.find(params[:id])
    if @game.destroy
      redirect_to admin_games_path, success: t(".destroy")
    else
      flash.now[:danger] = t(".not_destroy")
    end
  end

  private

  def game_params
    params.require(:game).permit(:name, :picture)
  end
end
