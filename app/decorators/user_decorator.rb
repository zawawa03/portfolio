class UserDecorator < Draper::Decorator
  delegate_all

  def fullname
    "#{last_name} #{first_name}"
  end

  def role_status
    I18n.t("enums.user.role.#{role}")
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
