class UsersController < ApplicationController
  def show
    @user = User.find(params[:id])
    @level = current_user.levels.new
    authorize @level
    authorize @user
  end

  def edit
    @user = User.find(current_user)
    authorize @user
  end

  def update
    @user = User.find(current_user)
    authorize @user
    @user.update(user_params)
    render :show
  end

  private
  def user_params
      params.require(:user).permit(:first_name,
                                  :last_name,
                                  :phone_number,
                                  :email_contact)
  end
end
