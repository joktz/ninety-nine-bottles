class GamesController < ApplicationController
  def index
    @games = current_user.games
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

  def show
    @game = Game.find(params[:id])
    @player = Player.new
    @players = @game.players
    @beer = Beer.new
    @beers = @game.beers
    @markers = @beers.geocoded.map do |beer|
      {
        lat: beer.latitude,
        lng: beer.longitude,
        info_window: render_to_string(partial: "popup", locals: { beer: beer })
      }
    end
  rescue ActiveRecord::RecordNotFound
    flash[:alert] = 'Game not found'
    redirect_to games_path
  end

  def edit
    @game = Game.find(params[:id])
  end

  def update
    @game = Game.find(params[:id])
    # Conditional to allow for AJAX requests
    if @game.update(game_params)
      respond_to do |format|
        format.html { redirect_to game_path(@game) }
        format.json { render json: { status: "Success", game: @game }, status: :ok }
      end
    else
      respond_to do |format|
        format.html { redirect_to game_path(@game), status: :unprocessable_entity }
        format.json { render json: { status: "error", errors: @game.errors.full_messages }, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @game = Game.find(params[:id])
    @game.destroy
    redirect_to games_path, notice: "Game deleted"
  end

  private

  def game_params
    params.require(:game).permit(:title, :rounds, :sessions, :round_mode, :inf_mode)
  end
end
