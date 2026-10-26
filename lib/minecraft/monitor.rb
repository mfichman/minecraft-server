require_relative 'status'

module Minecraft
  class Monitor
    def initialize(server, status: Status.new, logger: Rails.logger)
      @server = server
      @status = status
      @logger = logger
    end

    def idle?
      @server.reload
      count = @status.player_count
      attributes = {connections: count}
      attributes[:last_active_at] = Time.now.utc if count.positive?
      @server.update!(attributes)

      count.zero? && @server.inactive?
    rescue Status::Error => e
      # An unknown interval breaks the evidence of continuous inactivity.
      # Keep the previous count and require a full idle period after recovery.
      @server.update!(last_active_at: Time.now.utc)
      @logger.warn("Minecraft status check failed for #{@server.host}: #{e.message}")
      false
    end
  end
end
