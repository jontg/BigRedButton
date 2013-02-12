require 'rubygems'
require 'bundler/setup'
require 'hipchat'
require 'dream_cheeky'

DreamCheeky::BigRedButton.run do
    open do
        puts "Open"
    end

    close do
        puts "Close"
    end

    push do
        puts "Push"
    end
end
