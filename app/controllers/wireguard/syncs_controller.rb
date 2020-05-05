module Wireguard
  class SyncsController < RootController
    def create
      network = Network.find(params[:network_id])

      SyncJob.set(queue: network.host).perform_later(current_user, network)

      head :ok
    end
  end
end
