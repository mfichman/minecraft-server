module Wireguard
  def self.table_name_prefix
    'wireguard_'
  end

  def self.use_relative_model_naming?
    true
  end
end
