class TagDecorator < Draper::Decorator
  delegate_all

  def tag_category
    I18n.t("enums.tag.category.#{category}")
  end
end
