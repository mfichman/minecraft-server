module Wireguard
  class NetworksController < ApplicationController
    before_action :set_networks, only: [:index]
    before_action :set_network, only: [:show, :edit, :update]

    def new
      @network = Network.new
    end

    def create
      @network = Network.new(network_params)
      @network.build_key

      if @network.save
        redirect_to wireguard_network_path(@network)
      else
        render :new
      end
    end

    def update
      @network.assign_attributes(network_params)

      if @network.save
        redirect_to wireguard_network_path(@network)
      else
        render :new
      end
    end

    def destroy
      @network.destroy
    end

    private

    def network_params
      params.require(:network).permit(:ip_address, :host)
    end

    def set_network
      @network = Network.find(params[:id])
    end

    def set_networks
      @networks = Network.all
    end
  end
end
