module Minecraft
  class CommandJob < ApplicationJob
    def perform(server, command)
      Minecraft::Utils.run(command)
    end
  end
end
