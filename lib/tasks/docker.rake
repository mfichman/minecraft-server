namespace :docker do
  task :up do
    sh 'docker-compose -f docker-compose.yml -f docker-compose.development.yml up'
  end

  task :down do
    sh 'docker-compose -f docker-compose.yml -f docker-compose.development.yml down'
  end

  task :build do
    sh 'docker build -t mfichman/minecraft -f Dockerfile.minecraft .'
    sh 'docker build -t mfichman/minecraft:wireguard -f Dockerfile.wireguard .'
    sh 'docker build -t mfichman/minecraft:bundle -f Dockerfile.bundle .'
  end

  task :push do
    sh 'docker push mfichman/minecraft'
    sh 'docker push mfichman/minecraft:wireguard'
    sh 'docker push mfichman/minecraft:bundle'
  end
end
