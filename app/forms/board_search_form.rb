class BoardSearchForm
  include ActiveModel::Model
  include ActiveModel::Attributes

  attribute :word, :string
  attribute :tag_id, :integer

  def result
    @boards = Board.includes(:creator).order(created_at: :DESC)
    if word.present?
      sanitize_title_board = Room.sanitize_sql_like(word) + "%"
      sanitize_title_game = Game.sanitize_sql_like(word) + "%"
      @boards = @boards.joins(:game).where("boards.title LIKE ? OR games.name LIKE ?", sanitize_title_board, sanitize_title_game)
    end
    if tag_id.present?
      @boards = @boards.joins(:board_tags).where(board_tags: { tag_id: tag_id })
    end
    @boards
  end
end
