class AdminContactSearchForm
  include ActiveModel::Model
  include ActiveModel::Attributes

  attribute :name, :string
  attribute :sort, :integer

  def result
    @contacts = Contact.all

    if name.present?
      sanitized_name = "%#{Contact.sanitize_sql_like(name)}%"
      @contacts = @contacts.where("name LIKE ?", sanitized_name)
    end

    if sort.present?
      if sort == 0
        @contacts = @contacts.order(id: :DESC)
      else
        @contacts = @contacts.order(id: :ASC)
      end
    end
    @contacts
  end
end
