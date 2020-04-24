module Minecraft
  class CommandsController < ApplicationController

    def create
      server = Server.find(params[:server_id])

      CommandJob.perform_async(server, params[:text])

      head :ok
    end
  end
end
