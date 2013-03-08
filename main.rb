require 'rubygems'
require 'bundler/setup'
require 'hipchat'
require 'dream_cheeky'
require 'sonos'
require 'yubikey'

class RIQProductionPush < DreamCheeky::BigRedButton
    attr_accessor :running, :sonos_group, :keyboard

    def initialize
        puts "BRB.initialize"
        @running = true
        begin
          system = Sonos::System.new(Sonos::Discovery.new(1,"10.47.0.147").topology)
          @sonos_group = system.groups.first
        rescue
          puts "No sonos group found!"
          @sonos_group = nil
        end
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
            @keyboard = File.new("/dev/tty1", File::NONBLOCK | File::RDONLY)
            @sonos_group.pause unless @sonos_group.nil?
        end

        close do
            puts "Close"
            @keyboard.close unless @keyboard.nil?
            @sonos_group.play unless @sonos_group.nil?
        end

        push do
            puts "Push"
            begin
              otp = @keyboard.gets.chomp
              token = Yubikey::OTP::Verify.new(otp)
              if token.valid?
                puts "Test successful"
              end
            rescue Yubikey::OTP::InvalidOTPError
              puts "invalid OTP"
            end
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
