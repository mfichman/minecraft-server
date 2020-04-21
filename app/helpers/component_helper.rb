module ComponentHelper
  class Content
    attr_reader :yields

    def initialize(*fields)
      @yields = {}
    end

    def with(key)
      @yields[key] = yield
    end
  end

  def table(records, fields:)
    render 'components/table', records: records, fields: fields
  end

  def collection_actions
    render 'components/collection_actions'
  end

  def create_link
    button_link_to('Create', action: :create)
  end

  def card
    content = Content.new
    body = yield content
    render 'components/card', body: body, **content.yields
  end

  def button_link_to(text, url)
    link_to(text, url)
  end
end
