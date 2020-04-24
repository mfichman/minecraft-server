module Minecraft
  class LoadJob < ApplicationJob
    def perform(server, backup)
     # SaveJob.perform_now(server)

      minecraft = Docker::Container.get('minecraft')
      minecraft.stop

      config = {
        'HostConfig' => { 'VolumesFrom' => ['minecraft'] },
        'Image' => 'busybox',
      }

      mv = Docker::Container.create(config.merge('Cmd' => ['mv', '/minecraft/data/world', "/minecraft/data/world.backup.#{Time.now.iso8601}"]))
      mv.start
      puts mv.wait
      #mv.remove

      backup.file.open do |file|
        file.rewind
        tar = Docker::Container.create(config.merge('Cmd' => %w(tar -xzv -C /minecraft/data/test), 'OpenStdin' => true))
        tar.start
        puts tar.attach(stdin: file)
        puts tar.wait
        #tar.remove
      end

      server.update!(backup: backup)

      minecraft.start

      nil
    end
  end
end
      #system("docker stop minecraft", exception: true)
      #system("docker run --volumes-from minecraft -it alpine mv /minecraft/data/world{,.#{Time.now.iso8601}}", exception: true)
      #system("docker cp - minecraft:/minecraft/data/ < #{file.path}")
      #system("docker start minecraft", exception: true)

#      mv = Docker::Container.create(
#        'Image' => 'busybox',
#        'HostConfig' => { 'VolumesFrom' => ['minecraft'] },
#        'Cmd' => ['mv', '/minecraft/data/world', "/minecraft/data/world.backup.#{Time.now.iso8601}"]
#      )
#
#      mv.start
#      mv.wait
#
#      backup.file.open do |file|
#        tar = Docker::Container.create('Image' => 'busybox', 'HostConfig' => { 'VolumesFrom' => ['minecraft'] }, 'Cmd' => ['tar', '-xzv', '-C', '/minecraft/data/test'], 'OpenStdin' => true, 'StdinOnce' => true)
#        tar.start
#        tar.attach(stdin: file)
#      #  tar.remove
#      end
#
#      server.update!(backup: backup)
#
#      container.start
