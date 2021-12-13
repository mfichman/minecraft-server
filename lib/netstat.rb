# Copyright (c) 2012 David N. Welton
# 
# Permission is hereby granted, free of charge, to any person obtaining
# a copy of this software and associated documentation files (the
# "Software"), to deal in the Software without restriction, including
# without limitation the rights to use, copy, modify, merge, publish,
# distribute, sublicense, and/or sell copies of the Software, and to
# permit persons to whom the Software is furnished to do so, subject to
# the following conditions:
# 
# The above copyright notice and this permission notice shall be
# included in all copies or substantial portions of the Software.
# 
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
# NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
# LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
# OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
# WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

module Netstat
  PROC_NET_TCP = "/proc/net/tcp"

  TCP_STATES = {
    '00' => 'UNKNOWN',  # Bad state ... Impossible to achieve ...
    'FF' => 'UNKNOWN',  # Bad state ... Impossible to achieve ...
    '01' => 'ESTABLISHED',
    '02' => 'SYN_SENT',
    '03' => 'SYN_RECV',
    '04' => 'FIN_WAIT1',
    '05' => 'FIN_WAIT2',
    '06' => 'TIME_WAIT',
    '07' => 'CLOSE',
    '08' => 'CLOSE_WAIT',
    '09' => 'LAST_ACK',
    '0A' => 'LISTEN',
    '0B' => 'CLOSING'
  }

  # Read all the TCP data and return it.
  def self.read_tcp(path: nil)
    sockets = []
    File.readlines(path || PROC_NET_TCP)[1..-1].each do |line|
      # These are currently the fields listed in /proc/net/tcp
      # sl  local_address rem_address   st tx_queue rx_queue tr tm->when retrnsmt   uid  timeout inode 
      splitline = line.split
      localaddr, localport = splitline[1].split(':')
      remoteaddr, remoteport = splitline[2].split(':')
      socket = {
        :remote_address => remoteaddr,
        :remote_address_quad => [remoteaddr].pack("H*").unpack("C*").reverse.join("."),
        :remote_port => remoteport.to_i(16),
        :local_address => localaddr,
        :local_address_quad => [localaddr].pack("H*").unpack("C*").reverse.join("."),
        :local_port => localport.to_i(16),
        :state => TCP_STATES[splitline[3]]
      }

      sockets << socket
    end
    return sockets
  end

  # Takes a hash with the key and value to search for and returns all
  # matches.  If there are multiple parameters, has an AND behavior.
  def self.filter(path: nil, **params)
    return Netstat.read_tcp(path: path).select do |sock|
      retval = true
      params.keys.each do |k|
        unless sock[k] && (sock[k].to_s == params[k].to_s)
          retval = false
          break
        end
      end
      retval
    end
  end
end
