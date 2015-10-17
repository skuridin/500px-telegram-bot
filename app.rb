require 'bundler'
Bundler.require(:default)
require './lib/telegram'

bot = Telegram.new(ENV['BOT_API_KEY'])
bot.start_polling
