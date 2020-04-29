module Wireguard
  class SyncJob < ApplicationJob
    def perform(user, network)
      conf = NetworksController.render(partial: 'network', formats: 'conf', locals: { network: network })
      Utils.syncconf(conf)
    end
  end
end
