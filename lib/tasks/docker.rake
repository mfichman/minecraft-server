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
    sh 'docker build -t mfichman/minecraft:web -f Dockerfile.bundle --target web .'
    sh 'docker build -t mfichman/minecraft:worker -f Dockerfile.bundle --target worker .'
    sh 'docker build -t mfichman/minecraft:logger -f Dockerfile.bundle --target logger .'
  end

  task :push do
    sh 'docker push mfichman/minecraft'
    sh 'docker push mfichman/minecraft:wireguard'
    sh 'docker push mfichman/minecraft:bundle'
  end
end
