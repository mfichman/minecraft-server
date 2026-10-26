namespace :minecraft do
  task monitor: :environment do
    server = Minecraft::Server.find_or_create_by!(host: Figaro.env.server_name!)
    server.update!(last_active_at: Time.now.utc)
    monitor = Minecraft::Monitor.new(server)

    loop do
      Minecraft::IdleJob.set(queue: server.host).perform_later(server) if monitor.idle?

      sleep 1.minute
    end
  end
end
