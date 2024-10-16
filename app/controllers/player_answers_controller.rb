class PlayerAnswersController < ApplicationController
  before_action :set_answer, only: [:edit, :update]

  def new
    @player_answer = PlayerAnswer.new
    @player_answer.round = current_round
    @player_answer.beer = Beer.find(params[:beer_id])
    authorize @player_answer
  end

  def create
    @player_answer = PlayerAnswer.new(player_answer_params)
    authorize @player_answer
    @player_answer.round = current_round
  end

  def edit
  end

  def update
    if @player.update(player_answer_params)
      redirect_to ongoing_game_path(@player.round.game)
    end
  end

  private

  def player_answer_params
    params.require(:player_answer).permit(player_answers_attributes: [:id, :answer])
  end

  def set_answer
    @answer = PlayerAnswer.find(params[:id])
    authorize @answer
  end
end
