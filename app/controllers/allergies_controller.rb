class AllergiesController < ApplicationController
  def new
    @allergy = Allergy.new
    @level = Level.new
    authorize @allergy
  end

  def create
    @allergy = Allergy.new(name: allergy_params[:name])
    authorize @allergy

    if @allergy.save
      @level = Level.new(user_id: current_user.id,
                          allergy_id: @allergy.id,
                          allergy_level: allergy_params[:level][:allergy_level]).save
      redirect_to user_path(current_user)
    else
      redirect_to new_user_allergy_path(@allergy)
    end
  end

  def destroy
    @allergy =  Allergy.find(params[:id])
    authorize @allergy
    if @allergy.destroy
      redirect_to allergy_path(@event), notice: 'Allergy was successfully destroyed.'
    else
      redirect_to user_path(current_user)
    end
  end

  private

  def allergy_params
      params.require(:allergy).permit(:name,
                                  :level => [:allergy_level])
  end
end
