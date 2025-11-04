class Admin::TagsController < Admin::BaseController
  def index
    @tags = Tag.all
    @tag = Tag.new
  end

  def create
    @tags = Tag.all
    @tag = Tag.new(create_params)
    if @tag.save
      redirect_to admin_tags_path, success: t(".create")
    else
      flash.now[:danger] = t(".not_create")
      render :index, status: :unprocessable_entity
    end
  end

  def destroy
    @tag = Tag.find(params[:id])
    if @tag.destroy
      redirect_to admin_tags_path, success: t(".destroy")
    else
      flash.now[:danger] = t(".not_destroy")
      render :index, status: :unprocessable_entity
    end
  end

  private

  def create_params
    params.require(:tag).permit(:name, :category)
  end
end
