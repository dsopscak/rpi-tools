#!/usr/bin/env ruby
#
# TODO: Lots

require 'net/ssh'

config_file = File.join ENV['HOME'], '.remote_cmd.config'
if File.file? config_file
  load config_file
else
  puts "[#{config_file}] not found, using defaults"
  ALL_HOSTS = %w[pi01 pi02 pi03 pi04]
end

def run_cmd host, cmd
  Net::SSH.start(host, 'pi') do |ssh|
    output = "pi@#{host}:~ $ #{cmd}\n"
    output += ssh.exec!("#{cmd}")
    puts output
  end
end


def threaded_cmd cmd
  threads = []
  ALL_HOSTS.each do |host|
    threads << Thread.new do
      run_cmd host, cmd
    end
  end
  threads.each { _1.join }
end

def serial_cmd cmd
  ALL_HOSTS.each do |host|
    run_cmd host, cmd
  end
end


arg = ARGV[0]
if arg == '-s'
  puts ARGV[1]
  serial_cmd ARGV[1]
else
  puts arg
  threaded_cmd arg
end

