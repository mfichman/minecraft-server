module Minecraft
  class Log < ApplicationRecord
    belongs_to :server

    after_create :broadcast

    def filtered_text
      lines = text.split("\n")
      lines = lines.map do |line|
        "[#{created_at.strftime('%H:%M:%S')}] #{line.gsub(/\[\d{2}:\d{2}:\d{2}\] \[.*\]: /, '')}"
      end

      lines.join("\n").gsub('<', '&lt;').gsub('>', '&gt;').html_safe
    end

    private

    def broadcast
      LogsChannel.broadcast_to(server, filtered_text)
    end
  end
end
