require 'bundler'
Bundler.require(:default)
require './lib/subscriber'

subscriber = Subscriber.new(ENV['BOT_API_KEY'])
subscriber.subscribe do |update|
  p update
end
