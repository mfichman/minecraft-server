namespace :docker do

  SERVICES = Dir['services/**.yml'].map { |f| "--file=#{f}" }.join(' ')
  COMPOSE = "docker compose --project-directory=. --project-name=minecraft --env-file=.env #{SERVICES} --file=docker-compose.yml"
  IMAGES = %w(web worker logger monitor release boot)

  # Usage: rails docker:up[postgres]
  task :up do |_, args|
    sh "#{COMPOSE} up -d #{args.extras.join(' ')}"
  end

  task :logs do |_, args|
    sh "#{COMPOSE} logs -f #{args.extras.join(' ')}"
  end

  task :down do |_, args|
    sh "#{COMPOSE} down"
  end

  task :stop do |_, args|
    sh "#{COMPOSE} stop #{args.extras.join(' ')}"
  end

  task :build do
    sh 'docker build -t mfichman/minecraft --file=Dockerfile.minecraft .'

    IMAGES.each do |image|
      sh "docker build -t mfichman/minecraft:#{image} --file=Dockerfile.bundle --target=#{image} ."
    end
  end

  task :push do
    sh 'docker push mfichman/minecraft'

    IMAGES.each do |image|
      sh "docker push mfichman/minecraft:#{image}"
    end
  end
end
