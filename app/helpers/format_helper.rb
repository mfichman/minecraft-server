module FormatHelper
  def format(field, record)
    format_method = method("format_#{field}")

    value = record.public_send(field)

    if format_method.present?
      format_method.call(value)
    else
      value
    end
  end
end
