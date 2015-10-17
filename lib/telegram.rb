class Telegram
  def initialize(api_key, timeout = 20)
    @api_url = "https://api.telegram.org/bot#{api_key}/getUpdates"
    @offset = 0
    @timeout = timeout
  end

  def start_polling(&block)
    params = { offset: @offset, timeout: @timeout }
    res = RestClient.get @api_url, { accept: :json, params: params }

    unless res.code == 200
      return error_handler("Response code: #{res.code}", &block)
    end
    begin
      updates = JSON.parse(res.body)
    rescue JSON::ParserError => e
      return error_handler(e.message, &block)
    end
    unless updates['ok'] == true
      return error_handler("API response: #{updates['ok']}", &block)
    end

    updates['result'].each do |update|
      block.call update
      @offset = update['update_id'] + 1
    end

    self.send(__callee__, &block)
  end

  protected
    def error_handler(message, &block)
      puts message
      sleep(1)
      self.send(caller_locations(1,1)[0].label, &block)
    end
end
