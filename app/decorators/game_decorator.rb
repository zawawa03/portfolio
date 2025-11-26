class GameDecorator < Draper::Decorator
  delegate_all

  def picture_image(width, height)
    if picture.attached? && picture.blob.present?
      picture.variant(resize_to_limit: [ width, height ]).processed
    else
      ActionController::Base.helpers.asset_path("1.png")
    end
  end

  def board_image(width, height)
    if picture.attached? && picture.blob.present?
      picture.variant(resize_to_fill: [ width, height ]).processed
    else
      ActionController::Base.helpers.asset_path("1.png")
    end
  end
end
