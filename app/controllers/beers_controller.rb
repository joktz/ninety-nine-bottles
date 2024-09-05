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

  def show
  end

  def edit
    @beer = Beer.find(params[:id])
  end

  def update
    @beer = Beer.find(params[:id])
    @beer.update(beer_params)
    if @beer.save
      redirect_to game_path(@beer.game), notice: "Beer was successfully updated."
    else
      render :edit, status: :unprocessable_entity, notice: "Error when updating beer"
    end
  end

  def destroy
    @beer = Beer.find(params[:id])
    @beer.destroy
    redirect_to game_path(@beer.game), notice: "Beer was successfully deleted."
  end

  private

  def beer_params
    params.require(:beer).permit(:name, :style, :brewery, :origin, :ibu, :alc_content, :latitude, :longitude, :photo)
  end
end
