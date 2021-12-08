module ApplicationHelper
  def icon_tag(name)
    content_tag(:i, name, class: 'material-icons text-small pb-0')
  end

  def link_create(url)
    link_to(icon_tag(:add), url, class: 'btn btn-primary text-small btn-sm mb-4')
  end
end
