module ApplicationHelper
  def icon_tag(name)
    content_tag(:i, name, class: 'material-icons text-small pb-0')
  end
end
