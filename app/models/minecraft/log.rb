module Minecraft
  class Log < ApplicationRecord
    belongs_to :server

    after_create :broadcast

    def filtered_text
      lines = text.split(/\n|\r\n/)
      lines = lines.map do |line|
        "[#{created_at.in_time_zone.in_time_zone.strftime('%I:%M:%S %p')}] #{line.gsub(/\[\d{2}:\d{2}:\d{2}\] \[.*\]: /, '')}"
      end

      lines << '' if text.ends_with?("\n")

      lines.join("\r\n").gsub('<', '&lt;').gsub('>', '&gt;').html_safe
    end

    private

    def broadcast
      LogsChannel.broadcast_to(server, filtered_text)
    end
  end
end
