require 'json'
require 'socket'
require 'stringio'
require 'timeout'

module Minecraft
  # The Java server-list status protocol is supported by Minecraft 1.7+.
  class Status
    class Error < StandardError; end

    MAX_PACKET_SIZE = 2 * 1024 * 1024

    def initialize(host: '127.0.0.1', port: 25565, timeout: 5)
      @host = host
      @port = port
      @timeout = timeout
    end

    def player_count
      Timeout.timeout(@timeout) do
        Socket.tcp(@host, @port, connect_timeout: @timeout) do |socket|
          # Protocol 47 is sufficient for status requests, without logging in.
          handshake = varint(0) + varint(47) + string(@host) + [@port].pack('n') + varint(1)
          socket.write(packet(handshake) + packet(varint(0)))

          length = read_varint(socket)
          raise Error, 'Invalid status packet size' unless length.between?(1, MAX_PACKET_SIZE)

          response = StringIO.new(read_exact(socket, length))
          raise Error, 'Unexpected status packet type' unless read_varint(response).zero?

          json_length = read_varint(response)
          raise Error, 'Invalid status JSON size' unless json_length.between?(1, length)

          data = JSON.parse(read_exact(response, json_length).force_encoding(Encoding::UTF_8))
          raise Error, 'Unexpected data after status response' unless response.eof?

          count = data['players']['online'] if data.is_a?(Hash) && data['players'].is_a?(Hash)
          raise Error, 'Missing or invalid online player count' unless count.is_a?(Integer) && count >= 0

          count
        end
      end
    rescue IOError, SystemCallError, SocketError, Timeout::Error, JSON::ParserError, EncodingError => e
      raise Error, "Status request failed: #{e.message}"
    end

    private

    def varint(value)
      bytes = ''.b
      loop do
        byte = value & 0x7f
        value >>= 7
        bytes << (value.zero? ? byte : byte | 0x80)
        return bytes if value.zero?
      end
    end

    def string(value)
      bytes = value.b
      varint(bytes.bytesize) + bytes
    end

    def packet(payload)
      varint(payload.bytesize) + payload
    end

    def read_varint(stream)
      value = 0
      5.times do |index|
        byte = read_exact(stream, 1).getbyte(0)
        value |= (byte & 0x7f) << (7 * index)
        return value if (byte & 0x80).zero?
      end
      raise Error, 'Invalid status VarInt'
    end

    def read_exact(stream, length)
      bytes = ''.b
      while bytes.bytesize < length
        chunk = stream.read(length - bytes.bytesize)
        raise Error, 'Incomplete status response' if chunk.nil? || chunk.empty?

        bytes << chunk
      end
      bytes
    end
  end
end
