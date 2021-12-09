module Wireguard
  module Utils
    def self.syncconf(conf)
      conf_dir = Figaro.env.wireguard_dir || '/etc/wireguard'
      conf_file = File.join(conf_dir, 'wg1.conf')

      existing_config = File.exists?(conf_file)

      File.write(conf_file, conf)

      if existing_config
        command = "bash -c 'wg-quick up wg1; wg syncconf wg1 <(wg-quick strip /etc/wireguard/wg1.conf)'"
      else
        command = "bash -c 'wg-quick down wg1; wg-quick up wg1'"
      end

      system(command, exception: true)
    end
  end
end
