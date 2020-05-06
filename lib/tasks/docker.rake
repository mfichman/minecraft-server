namespace :docker do
  task :up do
    sh 'docker-compose -f docker-compose.yml -f docker-compose.development.yml up -d'
  end

  task :logs do
    sh 'docker-compose -f docker-compose.yml -f docker-compose.development.yml logs'
  end

  task :down do
    sh 'docker-compose -f docker-compose.yml -f docker-compose.development.yml down'
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
