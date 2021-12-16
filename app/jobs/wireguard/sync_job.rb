module Wireguard
  class SyncJob < ApplicationJob
    def perform(user, network)
      ToastsChannel.broadcast_to(user, SyncsController.render(partial: 'info'))

      conf = NetworksController.render('show', formats: [:conf], assigns: { network: network })
      Utils.syncconf(conf)

      ToastsChannel.broadcast_to(user, SyncsController.render(partial: 'success', locals: { network: network }))
    rescue => e
      ToastsChannel.broadcast_to(user, SyncsController.render(partial: 'error', locals: { message: e.message }))
    end
  end
end
