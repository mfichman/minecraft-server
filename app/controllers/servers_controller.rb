class ServersController < ApplicationController
  before_action :set_servers, only: [:index]

  private

  def set_servers
    @servers = Server.all
  end
end
