class AdminBoardSearchForm
  include ActiveModel::Model
  include ActiveModel::Attributes

  attribute :title, :string
  attribute :game, :integer
  attribute :sort, :integer

  def result
    @boards = Board.includes(:creator)

    if title.present?
      sanitized_title = "%#{Board.sanitize_sql_like(title)}%"
      @boards = @boards.where("title LIKE ?", sanitized_title)
    end

    if game.present?
      @boards = @boards.joins(:game).where(games: { id: game })
    end

    if sort.present?
      if sort == 0
        @boards = @boards.order(id: :DESC)
      else
        @boards = @boards.order(id: :ASC)
      end
    end
    @boards
  end
end
