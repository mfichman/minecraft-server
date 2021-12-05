namespace :docker do

  SERVICES = Dir['services/**.yml'].map { |f| "-f #{f}" }.join(' ')

  # Usage: rails docker:up[postgres]
  task :up, [:service] do |_, args|
    sh "docker compose #{SERVICES} -f docker-compose.yml up -d #{args[:service]}"
  end

  task :logs do
    sh "docker compose #{SERVICES} -f docker-compose.yml logs"
  end

  task :down do
    sh "docker compose #{SERVICES} -f docker-compose.yml down"
  end

  task :build do
    sh 'docker build -t mfichman/minecraft -f Dockerfile.minecraft .'
    sh 'docker build -t mfichman/minecraft:wireguard -f Dockerfile.wireguard .'
    sh 'docker build -t mfichman/minecraft:web -f Dockerfile.bundle --target web .'
    sh 'docker build -t mfichman/minecraft:worker -f Dockerfile.bundle --target worker .'
    sh 'docker build -t mfichman/minecraft:logger -f Dockerfile.bundle --target logger .'
    sh 'docker build -t mfichman/minecraft:release -f Dockerfile.bundle --target release .'
  end

  task :push do
    sh 'docker push mfichman/minecraft'
    sh 'docker push mfichman/minecraft:wireguard'
    sh 'docker push mfichman/minecraft:bundle'
  end
end
