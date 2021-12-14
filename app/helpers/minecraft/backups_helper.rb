module Minecraft
  module BackupsHelper
    def backup_name(backup)
      parts = []
      parts << backup.world.name if backup.world
      parts << 'autosave' if backup.autosave?
      parts << backup.created_at.strftime('%Y/%m/%d %l:%M %p')
      parts << number_to_human_size(backup.file.present? ? backup.file.byte_size : 0)
      parts.join(' - ')
    end
  end
end
