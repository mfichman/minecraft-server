module Wireguard
  module Utils
    def self.syncconf(conf)
      conf_dir = Figaro.env.wireguard_dir || '/etc/wireguard'
      conf_file = File.join(conf_dir, 'wg0.conf')

      new_config = File.exists?(conf_file)

      File.write(conf_file, conf)

      if new_config
        command = "wg-quick down wg0; wg-quick up wg0\n"
      else
        command = "wg-quick up wg0; wg syncconf wg0 <(wg-quick strip /etc/wireguard/wg0.conf)\n"
      end

      container = Docker::Container.get('wireguard')
      container.attach(stdin: StringIO.new(command))
    end
  end
end
