class Telegram
  def initialize(api_key, timeout = 20)
    @api_url = "https://api.telegram.org/bot#{api_key}/getUpdates"
    @offset = 0
    @timeout = timeout
  end

  def start_polling
    params = { offset: @offset, timeout: @timeout }
    res = RestClient.get @api_url, { accept: :json, params: params }

    return error_handler unless res.code == 200
    begin
      updates = JSON.parse(res.body)
    rescue JSON::ParserError => e
      return error_handler(e.message)
    end
    return error_handler unless updates['ok'] == true

    updates['result'].each do |update|
      process_update update
      @offset = update['update_id'] + 1
    end

    self.send(__callee__)
  end

  protected
    def process_update(update)
      p update
    end

    def error_handler(message = 'Problem with API')
      puts message
      sleep(1)
      pull
      return
    end
end
