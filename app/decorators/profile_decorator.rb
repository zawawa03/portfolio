class ProfileDecorator < Draper::Decorator
  delegate_all

  def avatar_image(width, height)
    if avatar.attached? && avatar.blob.present?
      avatar.variant(resize_to_limit: [ width, height ]).processed
    else
      ActionController::Base.helpers.assets_path("1.png")
    end
  end

  def profile_sex
    I18n.t("enums.profile.sex.#{sex}")
  end
  # Define presentation-specific methods here. Helpers are accessed through
  # `helpers` (aka `h`). You can override attributes, for example:
  #
  #   def created_at
  #     helpers.content_tag :span, class: 'time' do
  #       object.created_at.strftime("%a %m/%d/%y")
  #     end
  #   end
end
