module Minecraft
  class Log < ApplicationRecord
    belongs_to :server

    after_create :broadcast

    private

    def broadcast
      LogsChannel.broadcast_to(server, text)
    end
  end
end
