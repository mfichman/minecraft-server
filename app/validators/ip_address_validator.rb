class IpAddressValidator < ActiveModel::EachValidator

  def validate_each(record, attribute, value)
    IPAddr.new(value) unless value.blank?
  rescue IPAddr::InvalidAddressError
    record.errors.add(attribute, :invalid)
  end

end
