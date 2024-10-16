class PlayersController < ApplicationController
  before_action :set_player, only: %i[show edit update destroy]

  def new
    @player = Player.new
    authorize @player
  end

  def create
    @player = Player.new(player_params)
    @player.game = Game.find(params[:game_id])
    authorize @player
    if @player.save
      redirect_to game_path(@player.game), notice: "Player was successfully created."
    else
      redirect_to game_path(@player.game), alert: "Player could not be created."
    end
  end

  def show
  end

  def edit
  end

  def update
    # Conditional to allow for AJAX requests
    if @player.update(player_params)
      respond_to do |format|
        # Checks if the request is coming from the ongoing game page
        if params[:source] == 'ongoing'
          format.html { redirect_to ongoing_game_path(@player.game) }
        else
          format.html { redirect_to game_path(@player.game) }
          format.json { render json: { status: "Success", player: @player }, status: :ok }
        end
      end
    else
      respond_to do |format|
        format.html { redirect_to game_path(@player.game), status: :unprocessable_entity }
        format.json {render json: { status: "error", errors: @player.errors.full_messages }, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @player.destroy
    redirect_to game_path(@player.game), notice: "Player was successfully deleted."
  end

  private

  def set_player
    @player = Player.find(params[:id])
    authorize @player
  end

  def player_params
    params.require(:player).permit(:name, :score, player_answers_attributes: %i[id answer])
  end
end
