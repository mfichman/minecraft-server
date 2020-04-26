namespace :minecraft do
  task logs: :environment do
    server = Minecraft::Server.find_by(host: Figaro.env.host!)

    time = server.logs.order(:id).last&.created_at

    MinecraftUtils.logs(since: time) do |stream, chunk|
      puts stream, chunk
      server.logs.create!(text: chunk)
      puts chunk
    end
  end
end
