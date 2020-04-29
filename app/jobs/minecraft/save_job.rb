require_dependency('zip')

module Minecraft
  class SaveJob < ApplicationJob
    def perform(user, server, autosave: false)
      ToastsChannel.broadcast_to(user, SavesController.render(partial: 'info'))

      data_dir = Figaro.env.minecraft_data || '/minecraft/data'

      file = MinecraftUtils.save(data_dir)

      backup = server.world.backups.build(autosave: autosave)
      backup.file.attach(io: file, filename: 'world.zip', identify: false)
      backup.save!

      html = BackupsController.render(partial: 'option', locals: { backup: backup })
      SavesChannel.broadcast_to(server, { backup_id: backup.id, html: html })
      ToastsChannel.broadcast_to(user, SavesController.render(partial: 'success'))
    rescue => e
      ToastsChannel.broadcast_to(user, SavesController.render(partial: 'error', locals: { message: e.message }))
      raise
    ensure
      file.close
    end
  end
end


