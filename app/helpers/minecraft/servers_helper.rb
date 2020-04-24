module Minecraft
  module ServersHelper
    def backup_name(backup)
      "#{backup.world.name} - #{time_ago_in_words(backup.created_at)} ago"
    end
  end
end
