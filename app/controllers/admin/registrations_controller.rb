class Admin::RegistrationsController < Admin::BaseController
  def edit
    @user = User.find(params[:id])
  end

  # PUT /resource
  def update
    @user = User.find(params[:id])
    if @user.update_without_password(update_params)
      redirect_to admin_user_path(@user), success: t("admin.flash.update")
    else
      flash.now[:danger] = t("admin.flash.update_failed")
      render :edit, status: :unprocessaable_entity
    end
  end

  # DELETE /resource
  def destroy
    @user = User.find(params[:id])
    if @user.destroy
      redirect_to admin_users_path, success: t("admin.flash.delete")
    else
      redirect_to admin_users_path, danger: t("admin.flash.delete_failed")
    end
  end

  private

  def update_params
    params.require(:user).permit(:email, :first_name, :last_name, :role)
  end
end
