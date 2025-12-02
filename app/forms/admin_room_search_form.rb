class AdminRoomSearchForm
  include ActiveModel::Model
  include ActiveModel::Attributes

  attribute :title, :string
  attribute :category, :string
  attribute :game, :integer
  attribute :sort, :integer

  def result
    @rooms = Room.includes(:creator)

    if title.present?
      sanitized_title = "%#{Room.sanitize_sql_like(title)}%"
      @rooms = @rooms.where("title LIKE ?", sanitized_title)
    end

    if category.present?
      @rooms = @rooms.where(category: category)
    end

    if game.present?
      @rooms = @rooms.joins(:game).where(games: { id: game })
    end

    if sort.present?
      if sort == 0
        @rooms = @rooms.order(id: :DESC)
      else
        @rooms = @rooms.order(id: :ASC)
      end
    end
    @rooms
  end
end