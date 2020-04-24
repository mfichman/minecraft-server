module Minecraft
  class SavesController < ApplicationController
    def create
      server = Server.find(params[:server_id])

      SaveJob.perform_async(server)

      head :ok
    end
  end
end
