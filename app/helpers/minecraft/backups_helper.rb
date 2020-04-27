module Minecraft
  module BackupsHelper
    def backup_name(backup)
      parts = []
      parts << backup.world.name
      parts << 'autosave' if backup.autosave?
      parts << backup.created_at.in_time_zone('Eastern Time (US & Canada)').strftime('%Y/%m/%d %l:%M %P')
      parts << number_to_human_size(backup.file.present? ? backup.file.byte_size : 0)
      parts.join(' - ')
    end
  end
end
