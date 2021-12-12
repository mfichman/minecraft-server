module Minecraft
  class ServersController < RootController
    before_action :set_servers, only: [:index]
    before_action :set_server, only: [:show, :edit, :update, :destroy, :cloud_config]
    before_action :set_network, only: [:cloud_config]
    before_action :set_backups, only: [:show]
    before_action :set_jars, only: [:edit, :new]

    def new
      @server = Server.new
    end

    def create
      @server = Server.new(server_params)

      if @server.save
        redirect_to minecraft_path, notice: 'Server successfully created'
      else
        render :new
      end
    end

    def update
      @server.assign_attributes(server_params)

      if @server.save
        redirect_to minecraft_path, notice: 'Server successfully updated'
      else
        render :new
      end
    end

    def destroy
      @server.destroy

      redirect_to minecraft_path
    end

    def cloud_config
    end

    private

    def server_params
      params.require(:server).permit(:host, :max_idle_time_minutes, :ops_text, :properties_text, :jar_id, :modder_id, mod_ids: [])
    end

    def set_server
      @server = Server.find(params[:id])
    end

    def set_servers
      @servers = Server.order(:host)
    end

    def set_backups
      @backups = Backup.order(id: :desc)
    end

    def set_network
      @network = Wireguard::Network.find_by!(host: @server.host)
    end

    def set_jars
      @jars = Jar.order(version: :desc)
    end
  end
end
