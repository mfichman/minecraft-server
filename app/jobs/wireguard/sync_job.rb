module Wireguard
  class SyncJob < ApplicationJob
    def perform(user, network)
      conf = NetworksController.render('network.conf', assigns: { network: network })
      Utils.syncconf(conf)
    end
  end
end
