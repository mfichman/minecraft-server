namespace :docker do

  SERVICES = Dir['services/**.yml'].map { |f| "-f #{f}" }.join(' ')

  # Usage: rails docker:up[postgres]
  task :up, [:service] do |_, args|
    sh "docker compose --project-directory=. --env-file=.env #{SERVICES} -f docker-compose.yml up -d #{args[:service]}"
  end

  task :logs do
    sh "docker compose --project-directory=. --env-file=.env #{SERVICES} -f docker-compose.yml logs"
  end

  task :down do 
    sh "docker compose --project-directory=. --env-file=.env #{SERVICES} -f docker-compose.yml down"
  end

  task :build do
    sh 'docker build -t mfichman/minecraft -f Dockerfile.minecraft .'
    sh 'docker build -t mfichman/minecraft:web -f Dockerfile.bundle --target web .'
    sh 'docker build -t mfichman/minecraft:worker -f Dockerfile.bundle --target worker .'
    sh 'docker build -t mfichman/minecraft:logger -f Dockerfile.bundle --target logger .'
    sh 'docker build -t mfichman/minecraft:monitor -f Dockerfile.bundle --target monitor .'
    sh 'docker build -t mfichman/minecraft:release -f Dockerfile.bundle --target release .'
    sh 'docker build -t mfichman/minecraft:boot -f Dockerfile.bundle --target boot .'
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
