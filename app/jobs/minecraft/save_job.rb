require_dependency('zip')

module Minecraft
  class SaveJob < ApplicationJob
    def perform(user, server, autosave: false)
      ToastsChannel.broadcast_to(user, SavesController.render(partial: 'info'))
      server.logs.create!(text: "Saving\n")

      data_dir = Figaro.env.minecraft_data || '/minecraft/data'

      file = Minecraft::Utils.save(data_dir)

      backup = server.world.backups.build(autosave: autosave, parent: server.backup)
      backup.file.attach(io: file, filename: 'world.zip', identify: false)
      backup.save!

      html = BackupsController.render(partial: 'option', locals: { backup: backup })
      SavesChannel.broadcast_to(server, { backup_id: backup.id, html: html })
      ToastsChannel.broadcast_to(user, SavesController.render(partial: 'success'))
      server.logs.create!(text: "Saved: #{backup.id}, #{number_to_human_size(backup.file.byte_size)}\n")
    rescue => e
      ToastsChannel.broadcast_to(user, SavesController.render(partial: 'error', locals: { message: e.message }))
      server.logs.create!(text: "Save error: #{e.message}\n")
      raise
    ensure
      file&.close
    end
  end
end


