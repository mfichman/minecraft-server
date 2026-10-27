module Minecraft
  class ReloadsController < RootController
    def create
      server = Server.find(params[:server_id])

      ReloadJob.set(queue: server.host).perform_later(current_user, server)

      head :ok
    end
  end
end
