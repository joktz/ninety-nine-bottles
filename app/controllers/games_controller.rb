class GamesController < ApplicationController
  before_action :set_game, only: [:show, :edit, :update, :destroy, :start, :cancel, :ongoing]

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
      Player.create(game: @game, name: current_user.first_name)
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

  def start
    if @game.players.count > 1 && @game.beers.count > 1 && @game.may_start?
      @game.start!
      # Sets each player's score to 0
      @game.players.each do |player|
        player.update(score: 0)
      end
      redirect_to ongoing_game_path(@game), notice: "Game started"
    else
      redirect_to game_path(@game), alert: "You need at least 2 players and 2 beers to start the game!"
    end
  end

  def cancel
    if @game.ongoing?
      @game.cancel!
      @game.players.each do |player|
        player.update(score: nil)
      end
      redirect_to game_path(@game), notice: "Game cancelled"
    end
  end

  def ongoing
  end

  private

  def set_game
    @game = Game.find(params[:id])
    authorize @game
  end

  def game_params
    params.require(:game).permit(:title, :round_count).tap do |game_params|
      game_params[:round_count] = game_params[:round_count].to_i unless game_params[:round_count].nil?
    end
  end
end
