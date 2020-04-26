module Minecraft
  class CommandJob < ApplicationJob
    def perform(server, command)
      MinecraftUtils.run(command)
    end
  end
end
