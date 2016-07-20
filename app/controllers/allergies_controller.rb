class AllergiesController < ApplicationController
  def new
    @allergy = Allergy.new
    @level = Level.new
    authorize @allergy
  end

  def create
    @allergy = Allergy.new(user: current_user, name: @allergy.name)
    @level = Level.new(user: current_user, name: @allergy.level)
    authorize @allergy
    if @allergy.save
      redirect_to new_user_allergy_path(@allergy)
    else
      render user
    end
  end
  private
  def allergy_params
      params.require(:allergy).permit(:name,
                                  :level)
  end
end
