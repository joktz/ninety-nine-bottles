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
    @beers = @game.beers.order(:name)
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
    if @game.may_start?
      @game.start!
      redirect_to ongoing_game_path(@game), notice: "Game started"
    else
      redirect_to game_path(@game), alert: "Game could not be started"
    end
  end

  def end_round
    if @round.may_finish?
      @round.finish!
      redirect_to ongoing_game_path(@game), notice: "Round ended"
    else
      redirect_to ongoing_game_path(@game), alert: "Round could not be ended"
    end
  end

  def cancel
    if @game.may_cancel?
      @game.cancel!
      redirect_to game_path(@game), notice: "Game cancelled"
    else
      # This works for now, but probably would be better to prevent a page reload
      redirect_to ongoing_game_path(@game), alert: "Game could not be cancelled"
    end
  end

  def ongoing
    @current_round = @game.rounds.find_by(aasm_state: "ongoing")
    @round_beers = @current_round.beers.order(:code) if @current_round
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
