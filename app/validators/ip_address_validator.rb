class IpAddressValidator < ActiveModel::EachValidator

  def validate_each(record, attribute, value)
    return if value.blank?

    addr = IPAddr.new(value)
    prefix = options[:prefix]

    if prefix && prefix != addr.prefix
      record.errors.add(attribute, :invalid_ip_prefix, prefix: prefix)
    end

  rescue IPAddr::InvalidAddressError
    record.errors.add(attribute, :invalid)
  end
end
