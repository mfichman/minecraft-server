task worker: :environment do
  queues = []
  queues << 'default'
  queues << Figaro.env.server_name if Figaro.env.server_name?
  queues = queues.map { |q| "--queue #{q}" }

  exec "#{RbConfig.ruby} bin/sidekiq #{queues} --concurrency 1"
end
