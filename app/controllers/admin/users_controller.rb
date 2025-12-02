class Admin::UsersController < Admin::BaseController
  def  index
    @users = User.all.order(id: :DESC)
  end

  def show
    @user = User.find(params[:id])
    @profile = @user.profile
  end

  def search
    @user_search = AdminUserSearchForm.new(search_params)
    @users = @user_search.result
  end

  private

  def search_params
    params.require(:q).permit(:first_name, :last_name, :role, :sort)
  end
end
