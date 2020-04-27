namespace :minecraft do
  task logs: :environment do
    server = Minecraft::Server.find_by(host: Figaro.env.host!)

    time = server.logs.order(:id).last&.created_at

    MinecraftUtils.logs(since: time) do |chunk, stream|
      server.logs.create!(text: chunk)
    end
  end
end
