module Minecraft
  class SavesController < ApplicationController
    def create
      server = Server.find(params[:server_id])

      SaveJob.set(queue: server.host).perform_later(current_user, server)

      head :ok
    end
  end
end
