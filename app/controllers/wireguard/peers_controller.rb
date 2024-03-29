module Wireguard
  class PeersController < RootController
    before_action :set_peer, only: [:show, :edit, :update, :destroy]

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

      redirect_to wireguard_network_path(@peer.network)
    end

    private

    def peer_params
      params.require(:peer).permit(:name, :network_id, :ip_address)
    end

    def set_peer
      @peer = Peer.find(params[:id])
    end

    def set_peers
      @peers = Peer.order(:ip_address)
    end
  end
end
