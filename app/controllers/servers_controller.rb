class ServersController < ApplicationController
  before_action :set_servers, only: [:index]
  before_action :set_server, only: [:show, :edit, :update]

  def new
    @server = Server.new
  end

  def create
    @server = Server.new(server_params)

    if @server.save
      redirect_to servers_path
    else
      render :new
    end
  end

  def update
    @server.assign_attributes(server_params)

    if @server.save
      redirect_to servers_path
    else
      render :new
    end
  end

  def destroy
    @server.destroy
  end

  private

  def server_params
    params.require(:server).permit(:host)
  end

  def set_server
    @server = Server.find(params[:id])
  end

  def set_servers
    @servers = Server.all
  end
end
