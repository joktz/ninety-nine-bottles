class BeersController < ApplicationController
  before_action :set_beer, only: [:show, :edit, :update, :destroy]

  def new
    @beer = Beer.new
    authorize @beer
  end

  def create
    @beer = Beer.new(beer_params)
    @beer.game = Game.find(params[:game_id])
    authorize @beer
    if @beer.save
      redirect_to game_path(@beer.game), notice: "Beer was successfully added."
    else
      render "games/show", status: :unprocessable_entity, notice: "Error when creating beer"
    end
  end

  def show
  end

  def edit
  end

  def update
    @beer.update(beer_params)
    if @beer.save
      redirect_to game_path(@beer.game), notice: "Beer was successfully updated."
    else
      redirect_to game_path(@beer.game), notice: "Error when updating beer"
    end
  end

  def destroy
    @beer.destroy
    redirect_to game_path(@beer.game), notice: "Beer was successfully deleted."
  end

  private

  def set_beer
    @beer = Beer.find(params[:id])
    authorize @beer
  end

  def beer_params
    params.require(:beer).permit(:name, :style, :brewery, :origin, :ibu, :alc_content, :latitude, :longitude, :photo, :round_id)
  end
end
