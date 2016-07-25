class AllergiesController < ApplicationController
  def new
    @level = current_user.levels.new
    authorize @level
  end

  def edit
    @level = current_user.levels.find(params[:id])
    authorize @level
  end

  def create
    @level = current_user.levels.new(allergy_params)
    authorize @level

    if @level.save
      redirect_to user_path(current_user), notice: "Allergy was successfully added."
    else
      flash[:alert] = "Allergy could not be added!"
      render :new
    end
  end

  def update
    @level = Level.find(params[:id])
    authorize @level
    @level.allergy_level = params[:level][:allergy_level]

    if @level.save
      redirect_to user_path(current_user), notice: "Level was successfully added."
    else
      flash[:alert] = "Level could not be added!"
      render :create
    end
  end


  def destroy
    level_a_suppr = current_user.levels.find(params[:id])
    authorize level_a_suppr
    if level_a_suppr.destroy
      redirect_to user_path(current_user), notice: 'Allergy was successfully destroyed.'
    else
      redirect_to user_path(current_user), alert: 'Allergy could not be destroyed.'
    end
  end

  private

  def allergy_params
      params.require(:level).permit(:allergy_level,
                                  :allergy_id)
  end
end
