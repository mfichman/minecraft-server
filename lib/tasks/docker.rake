namespace :docker do
  task :up do
    sh 'docker-compose -f docker-compose.yml -f docker-compose.development.yml up'
  end

  task :down do
    sh 'docker-compose -f docker-compose.yml -f docker-compose.development.yml down'
  end

  task :build do
    sh 'docker-compose -f docker-compose.yml -f docker-compose.development.yml build'
  end

  task :push do
    sh 'docker-compose -f docker-compose.yml -f docker-compose.development.yml push'
  end
end
