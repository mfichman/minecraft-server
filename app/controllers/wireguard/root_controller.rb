module Wireguard
  class RootController < ApplicationController
    before_action :set_networks

    private

    def set_networks
      @networks = Network.order(:host)
    end

    def verify_authorization
      authorize [:wireguard, :root]
    end
  end
end

