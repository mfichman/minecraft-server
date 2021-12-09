namespace :minecraft do
  task logger: :environment do
    server = Minecraft::Server.find_or_create_by!(host: Figaro.env.server_name!)
    time = server.logs.order(:id).last&.created_at

    queue = Queue.new

    Thread.new do
      buffer = []

      while chunk = queue.deq do
        buffer << chunk

        begin
          1024.times { buffer << queue.deq(true) }
        rescue ThreadError
          # blocked
        end

        server.logs.create!(text: buffer.join)
        buffer.clear
      end
    end

    Minecraft::Utils.logs(since: time) do |chunk|
      queue << chunk
    end

  ensure
    queue&.close
  end
end
