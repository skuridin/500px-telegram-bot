require 'bundler'
require 'open-uri'
Bundler.require(:default)

API_URL = "https://api.telegram.org/bot#{ENV['BOT_API_KEY']}/getUpdates"

def process(update)
  p update
end

def pull(offset = 0)
  params = { offset: offset, timeout: 20 }
  res = RestClient.get API_URL, { accept: :json, params: params }

  if res.code != 200
    sleep(1)
    pull(offset)
    return
  end

  begin
    updates = JSON.parse(res.to_s)
  rescue JSON::ParserError => e
    puts e.message
    sleep(1)
    pull(offset)
    return
  end

  if updates['ok'] != true
    sleep(1)
    pull(offset)
    return
  end

  updates['result'].each do |update|
    process update
    offset = update['update_id'] + 1
  end

  pull offset
end

pull
