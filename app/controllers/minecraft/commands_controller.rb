module Minecraft
  class CommandsController < RootController

    def create
      server = Server.find(params[:server_id])

      CommandJob.set(queue: server.host).perform_later(server, params[:text])

      head :ok
    end
  end
end
