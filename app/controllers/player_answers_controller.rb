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
  end

  private

  def player_answer_params
    params.require(:player_answer).permit(:answer)
  end

  def set_answer
    @answer = PlayerAnswer.find(params[:id])
    authorize @answer
  end
end
