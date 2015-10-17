require 'bundler'
Bundler.require(:default)
require 'open-uri'
require 'pathname'
require './lib/subscriber'
require './lib/speaker'
require './lib/five_hundred'
require './lib/commander'

subscriber = Subscriber.new ENV['BOT_API_KEY']
speaker = Speaker.new ENV['BOT_API_KEY']
fhp = FiveHundred.new ENV['FHP_API_KEY']
commander = Commander.new speaker, fhp

subscriber.subscribe do |update|
  commander.process update
end
