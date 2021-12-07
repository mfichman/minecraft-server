module ApplicationHelper
  def icon_tag(name)
    content_tag(:i, name, class: 'material-icons text-small pb-0')
  end

  def link_create(url)
    link_to(icon_tag(:add) + ' Create', url, class: 'btn btn-primary btn-sm mb-4')
  end
end
