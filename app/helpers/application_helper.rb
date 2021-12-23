module ApplicationHelper
  def icon_tag(name, **args)
    content_tag(:i, name, class: "material-icons pb-0 #{args[:class] || ''}")
  end

  def link_create(url)
    link_to(icon_tag(:add), url, class: 'btn btn-primary text-small btn-sm mb-4')
  end

  def nav_link(icon, text, path)
    active = 'active' if request.path.starts_with?(path)

    link_to(path, class: "nav-link flex-basis-0 flex-grow-1 flex-shrink-1 flex-md-grow-0 #{active}") do 
      content_tag(:div, class: 'd-flex w-100 align-items-center flex-column flex-md-row') do
        icon_tag(icon) + content_tag(:span, text, class: 'ps-md-2')
      end
    end
  end

  def header_tag(title, prev: nil)
    content_tag(:div, class: 'bg-dark d-flex sticky-top position-md-static justify-content-between align-items-end pt-1 pb-3 mt-0 mb-2') do
      header = content_tag(:h1, title, class: 'm-0')

      next header if prev.nil?

      text, url = prev

      before = content_tag(:div, class: 'flex-basis-0 flex-grow-1 d-md-none') do
        link_to(url, class: 'text-decoration-none') do
          content_tag(:div, class: 'd-flex align-items-center pe-3') do
            icon_tag(:arrow_back_ios, class: 'fs-4')# + content_tag(:span, text)
          end
        end
      end

      after = content_tag(:div, '', class: 'flex-basis-0 flex-grow-1 d-md-none')

      before + header + after
    end
  end
end
