class PlayersController < ApplicationController

  def new
    @player = Player.new
  end

  def create
    @player = Player.new(player_params)
    @player.game = Game.find(params[:game_id])
    if @player.save
      redirect_to game_path(@player.game), notice: "Player was successfully created."
    else
      render "games/show", status: :unprocessable_entity, notice: "Error when creating player"
    end
  end

  private

  def player_params
    params.require(:player).permit(:name, :score)
  end
end
