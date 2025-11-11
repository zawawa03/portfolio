class ProfilesController < ApplicationController
  def new
    @profile = Profile.new
  end

  def show
    @user = User.find(params[:id])
    @profile = @user.profile
  end

  def edit
    @profile = current_user.profile
  end

  def create
    @profile = current_user.build_profile(profile_params)
    if @profile.save
      redirect_to root_path, success: t(".create")
    else
      flash.now[:danger] = t(".not_create")
      render :new, status: :unprocessable_entity
    end
  end

  def update
    @profile = current_user.profile
    if @profile.update(profile_params)
      redirect_to user_profile_path(current_user), success: t(".update")
    else
      flash.now[:danger] = t(".not_update")
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def profile_params
    params.require(:profile).permit(:nickname, :sex, :introduction, :avatar)
  end
end
