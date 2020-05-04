module Minecraft
  class ServersController < ApplicationController
    before_action :set_servers, only: [:index]
    before_action :set_server, only: [:show, :edit, :update, :destroy]
    before_action :set_backups, only: [:show]

    def new
      @server = Server.new
    end

    def create
      @server = Server.new(server_params)

      if @server.save
        redirect_to minecraft_path
      else
        render :new
      end
    end

    def update
      @server.assign_attributes(server_params)

      if @server.save
        redirect_to minecraft_path
      else
        render :new
      end
    end

    def destroy
      @server.destroy

      redirect_to minecraft_path
    end

    private

    def server_params
      params.require(:server).permit(:host)
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
  end
end
