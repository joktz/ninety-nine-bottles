class GamesController < ApplicationController
  def index
    @games = current_user.games
  end

  def show
    @game = Game.find(params[:id])
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

  private

  def game_params
    params.require(:game).permit(:title, :rounds, :sessions, :round_mode, :inf_mode)
  end
end


t.string "title"
t.integer "rounds"
t.bigint "user_id", null: false
t.integer "sessions"
t.string "round_mode"
t.string "inf_mode"
t.datetime "created_at", null: false
t.datetime "updated_at", null: false
t.index ["user_id"], name: "index_games_on_user_id"
