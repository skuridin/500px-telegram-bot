require 'bundler'
Bundler.require(:default)
require './lib/subscriber'
require './lib/speaker'

subscriber = Subscriber.new(ENV['BOT_API_KEY'])
speaker = Speaker.new(ENV['BOT_API_KEY'])

subscriber.subscribe do |update|
  chat_id = update['message']['chat']['id']
  reply_id = update['message']['message_id']
  speaker.send_message(chat_id, 'hey!', reply_id)
end
