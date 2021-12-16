namespace :docker do

  SERVICES = Dir['services/**.yml'].map { |f| "--file=#{f}" }.join(' ')
  COMPOSE = "docker compose --project-directory=. --project-name=minecraft --env-file=.env #{SERVICES} --file=docker-compose.yml"

  # Usage: rails docker:up[postgres]
  task :up, [:service] do |_, args|
    sh "#{COMPOSE} up -d #{args[:service]}"
  end

  task :logs do
    sh "#{COMPOSE} logs"
  end

  task :down do 
    sh "#{COMPOSE} down"
  end

  task :build do
    sh 'docker build -t mfichman/minecraft --file=Dockerfile.minecraft .'
    sh 'docker build -t mfichman/minecraft:web --file=Dockerfile.bundle --target=web .'
    sh 'docker build -t mfichman/minecraft:worker --file=Dockerfile.bundle --target=worker .'
    sh 'docker build -t mfichman/minecraft:logger --file=Dockerfile.bundle --target=logger .'
    sh 'docker build -t mfichman/minecraft:monitor --file=Dockerfile.bundle --target=monitor .'
    sh 'docker build -t mfichman/minecraft:release --file=Dockerfile.bundle --target=release .'
    sh 'docker build -t mfichman/minecraft:boot --file=Dockerfile.bundle --target=boot .'
  end

  task :push do
    sh 'docker push mfichman/minecraft'
    sh 'docker push mfichman/minecraft:logger'
    sh 'docker push mfichman/minecraft:worker'
    sh 'docker push mfichman/minecraft:web'
    sh 'docker push mfichman/minecraft:monitor'
    sh 'docker push mfichman/minecraft:release'
    sh 'docker push mfichman/minecraft:boot'
  end
end
