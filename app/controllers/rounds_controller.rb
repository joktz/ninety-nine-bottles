class RoundsController < ApplicationController
  def create
    @round = Round.new
    @round.game = Game.find(params[:game_id])
  end

  private

  def round_params
    params.require(:round).permit(:game_id, :round_number)
  end
end
