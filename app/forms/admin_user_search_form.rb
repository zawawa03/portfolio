class AdminUserSearchForm
  include ActiveModel::Model
  include ActiveModel::Attributes

  attribute :first_name, :string
  attribute :last_name, :string
  attribute :role_name, :string
  attribute :sort, :integer

  def result
    @users = User.all

    if first_name.present?
      sanitized_first_name = "%#{User.sanitize_sql_like(first_name)}%"
      @users = @users.where("first_name LIKE ?", sanitized_first_name)
    end

    if last_name.present?
      sanitized_last_name = "%#{User.sanitize_sql_like(last_name)}%"
      @users = @users.where("last_name LIKE ?", sanitized_last_name)
    end

    if role_name.present?
      @users = @users.where(role: role_name)
    end

    if sort.present?
      if sort == 0
        @users = @users.order(id: :DESC)
      else
        @users = @users.order(id: :ASC)
      end
    end
    @users
  end
end
