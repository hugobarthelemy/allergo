class AllergiesController < ApplicationController
  def new
    @level = current_user.levels.new
    authorize @level
  end

  def create
    @level = current_user.levels.new(allergy_params)
    authorize @level

    if @level.save
      redirect_to user_path(current_user), notice: "Allergy was successfully add."
    else
      flash[:alert] = "Allergy wasn't add !"
      render :new
    end
  end

  def destroy
    level_a_suppr = current_user.levels.find(params[:id])
    authorize level_a_suppr
    if level_a_suppr.destroy
      redirect_to user_path(current_user), notice: 'Allergy was successfully destroyed.'
    else
      redirect_to user_path(current_user), alert: 'Allergy was NOT successfully destroyed.'
    end
  end

  private

  def allergy_params
      params.require(:level).permit(:allergy_level,
                                  :allergy_id)
  end
end
