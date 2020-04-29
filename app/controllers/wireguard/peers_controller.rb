module Wireguard
  class PeersController < ApplicationController
    before_action :set_peer, only: [:show, :edit, :update]

    def new
      @peer = Peer.new(network_id: params[:network_id])
    end

    def create
      @peer = Peer.new(peer_params)
      @peer.build_key
      @peer.assign_ip_address

      if @peer.save
        redirect_to wireguard_network_path(@peer.network)
      else
        render :new
      end
    end

    def update
      @peer.assign_attributes(peer_params)

      if @peer.save
        redirect_to wireguard_network_path(@peer.network)
      else
        render :new
      end
    end

    def destroy
      @peer.destroy
    end

    private

    def peer_params
      params.require(:peer).permit(:name, :network_id)
    end

    def set_peer
      @peer = Peer.find(params[:id])
    end

    def set_peers
      @peers = Peer.all
    end
  end
end
