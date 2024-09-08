class PlayersController < ApplicationController

  def new
    @player = Player.new
  end

  def show
    @player = Player.find(params[:id])
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

  def edit
    @player = Player.find(params[:id])
  end

  def update
    @player = Player.find(params[:id])
    # Conditional to allow for AJAX requests
    if @player.update(player_params)
      respond_to do |format|
        format.html { redirect_to game_path(@player.game) }
        format.json { render json: { status: "Success", player: @player }, status: :ok }
      end
    else
      respond_to do |format|
        format.html { redirect_to game_path(@player.game), status: :unprocessable_entity }
        format.json {render json: { status: "error", errors: @player.errors.full_messages }, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @player = Player.find(params[:id])
    @player.destroy
    redirect_to game_path(@player.game), notice: "Player was successfully deleted."
  end

  private

  def player_params
    params.require(:player).permit(:name, :score)
  end
end
