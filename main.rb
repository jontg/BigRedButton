require 'rubygems'
require 'bundler/setup'
require 'hipchat'
require 'dream_cheeky'
require 'sonos'

class RIQProductionPush < DreamCheeky::BigRedButton
    attr_accessor :running, :sonos_group

    def initialize
        puts "initialize"
        @running = true
        system = Sonos::System.new(Sonos::Discovery(1,"10.47.0.147").topology)
        @sonos_group = system.groups.first
    end

    def stop
        puts "BRB.stop"
        @running = false
    end

    def poll_usb
        init_loop
        begin
            case check_button
            when OPEN
                open! unless already_open?
            when DEPRESSED
                push! unless already_pushed?
            when CLOSED
                close! unless already_closed?
            end
            sleep 0.1
        end while(@running)
    end

    def run_block
        open do
            puts "Open"
            @sonos_group.pause
        end

        close do
            puts "Close"
            @sonos_group.play
        end

        push do
            puts "Push"
        end
    end
end

brb = RIQProductionPush.new

Signal.trap RUBY_PLATFORM =~ /win32/ ? 'KILL' : 'TERM' do
  $stderr.puts "Received stop signal..."
  brb.stop
end

Signal.trap 'INT' do
  $stderr.puts "Received stop signal..."
  brb.stop
end

brb.run(&brb.run_block)

