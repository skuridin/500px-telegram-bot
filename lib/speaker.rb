class Speaker
  def initialize(api_key)
    @api_url = "https://api.telegram.org/bot#{api_key}"
  end

  def send_message(chat_id, text, reply_id = nil)
    params = { chat_id: chat_id, text: text }
    params[:reply_to_message_id] = reply_id unless reply_id.nil?
    post "#{@api_url}/sendMessage", params
  end

  def send_photo(chat_id, file, reply_id = nil)
    params = { chat_id: chat_id, photo: file }
    params[:reply_to_message_id] = reply_id unless reply_id.nil?
    post "#{@api_url}/sendPhoto", params
  end

  protected
    def post(url, params)
      headers = { content_type: :json, accept: :json }
      begin
        RestClient.post url, params, headers
      rescue RestClient::Exception => e
        puts e.message
      end
    end
end
