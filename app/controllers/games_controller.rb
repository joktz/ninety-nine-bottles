class GamesController < ApplicationController
  before_action :set_game, only: [:show, :edit, :update, :destroy]

  def index
    @games = policy_scope(Game).all
  end

  def new
    @game = Game.new
    @game.user = current_user
    authorize @game
  end

  def create
    @game = Game.new(game_params)
    @game.user = current_user
    authorize @game
    if @game.save
      redirect_to game_path(@game)
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show
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
  end

  def update
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
    @game.destroy
    redirect_to games_path, notice: "Game deleted"
  end

  private

  def set_game
    @game = Game.find(params[:id])
    authorize @game
  end

  def game_params
    params.require(:game).permit(:title)
  end
end
