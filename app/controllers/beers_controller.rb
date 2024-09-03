class BeersController < ApplicationController
  def new
    @beer = Beer.new
  end

  def create
    @beer = Beer.new(beer_params)
    @beer.game = Game.find(params[:game_id])
    if @beer.save
      redirect_to game_path(@beer.game), notice: "Beer was successfully added."
    else
      render "games/show", status: :unprocessable_entity, notice: "Error when creating beer"
    end
  end

  private

  def beer_params
    params.require(:beer).permit(:name, :style, :brewery, :origin, :ibu, :alc_content, :latitude, :longitude, :photo)
  end

end
