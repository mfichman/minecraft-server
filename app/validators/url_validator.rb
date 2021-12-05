class UrlValidator < ActiveModel::EachValidator

  def validate_each(record, attribute, value)
    return if value.blank?

    addr = URI.parse(value)
  rescue URI::InvalidURIError
    record.errors.add(attribute, :invalid)
  end
end
