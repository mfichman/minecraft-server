module Wireguard
  module Utils
    def self.syncconf(conf)
      conf_dir = Figaro.env.wireguard_dir || '/etc/wireguard'
      conf_file = File.join(conf_dir, 'wg0.conf')

      File.write(conf_file, conf)

      command = "wg syncconf wg0 <(wg-quick strip /etc/wireguard/wg0.conf)\n"

      container = Docker::Container.get('wireguard')
      container.attach(stdin: StringIO.new(command))
    end
  end
end
