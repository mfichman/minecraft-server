module Minecraft
  class RootController < ApplicationController
    before_action :set_worlds
    before_action :set_servers

    private

    def set_worlds
      @worlds = World.order(:name)
    end

    def set_servers
      @servers = Server.order(:host)
    end

    def verify_authorization
      authorize [:minecraft, :root]
    end
  end
end
