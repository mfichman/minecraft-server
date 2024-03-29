require_dependency('zip')

module Minecraft
  class SaveJob < ApplicationJob
    def perform(user, server, autosave: false)
      ToastsChannel.broadcast_to(user, SavesController.render(partial: 'info'))
      server.logs.create!(text: "[Controller] Saving\n")

      data_dir = Figaro.env.minecraft_data || '/minecraft/data'

      file = Minecraft::Utils.save(data_dir)

      backup = server.world.backups.build(autosave: autosave, parent: server.backup)
      backup.file.attach(io: file, filename: 'world.zip', identify: false)
      backup.save!
      server.update!(backup: backup) unless autosave

      html = BackupsController.render(partial: 'option', locals: { backup: backup })
      SavesChannel.broadcast_to(server, { backup_id: server.backup_id, html: html })
      ToastsChannel.broadcast_to(user, SavesController.render(partial: 'success'))
      server.logs.create!(text: "[Controller] Saved: #{backup.id}, #{backup.file.byte_size} bytes\n")
    rescue => e
      ToastsChannel.broadcast_to(user, SavesController.render(partial: 'error', locals: { message: e.message }))
      server.logs.create!(text: "[Controller] Save error: #{e.message}\n")
      raise
    ensure
      file&.close
    end
  end
end


