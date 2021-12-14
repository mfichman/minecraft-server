module Minecraft
  class IdleJob < ApplicationJob
    def perform(server)
      server.logs.create!(text: "Server is idle\n")

      SaveJob.perform_now(nil, server, autosave: true)
      ShutdownJob.perform_now(nil, server) 
    end
  end
end
