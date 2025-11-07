class RoomSearchForm
  include ActiveModel::Model
  include ActiveModel::Attributes

  attribute :word, :string
  attribute :mode_tag, :integer
  attribute :style_tag, :integer
  attribute :ability_tag, :integer

  def result
    @rooms = Room.includes(:creator).where(category: 0)
    tag_ids = [ mode_tag, style_tag, ability_tag ].compact
    if word.present?
      sanitize_word_room = Room.sanitize_sql_like(word) + "%"
      sanitize_word_game = Game.sanitize_sql_like(word) + "%"
      @rooms = @rooms.joins(:game).where("games.name LIKE ? OR rooms.title LIKE ?", sanitize_word_game, sanitize_word_room)
    end
    @rooms = @rooms.joins(:room_tags).where(room_tags: { tag_id: tag_ids })
                                     .group("rooms.id")
                                     .having("COUNT(DISTINCT room_tags.tag_id) = ?", tag_ids.size) if tag_ids.present?
    @rooms
  end
end
