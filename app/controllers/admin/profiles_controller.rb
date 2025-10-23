class Admin::ProfilesController < Admin::BaseController
  def edit
    @profile = Profile.find(params[:id])
  end

  def update
    @profile = Profile.find(params[:id])
    @user = @profile.user
    if @profile.update(update_params)
      redirect_to admin_user_path(@user), success: t(".update")
    else
      flash.now[:danger] = t(".not_update")
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def update_params
    params.require(:profile).permit(:nickname, :sex, :introduction, :avatar)
  end
end
