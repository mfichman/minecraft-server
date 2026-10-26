module Minecraft
  class ShutdownsController < RootController
    def create
      server = Server.find(params[:server_id])

      ShutdownJob.set(queue: server.host).perform_later(current_user, server)

      head :ok
    end
  end
end
