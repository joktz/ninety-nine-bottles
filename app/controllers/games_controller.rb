class GamesController < ApplicationController
  def index
    @games = current_user.games
  end

  def show
    @game = Game.find(params[:id])
    @player = Player.new
    @players = @game.players
    @beer = Beer.new
    @beers = @game.beers
  rescue ActiveRecord::RecordNotFound
    flash[:alert] = 'Game not found'
    redirect_to games_path
  end

  def new
    @game = Game.new
  end

  def create
    @game = Game.new(game_params)
    @game.user = current_user
    if @game.save
      redirect_to game_path(@game)
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def game_params
    params.require(:game).permit(:title, :rounds, :sessions, :round_mode, :inf_mode)
  end
end
