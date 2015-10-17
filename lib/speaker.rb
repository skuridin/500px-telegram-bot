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
    return send_not_found chat_id, reply_id if file.nil?
    params = { chat_id: chat_id, photo: file }
    params[:reply_to_message_id] = reply_id unless reply_id.nil?
    post "#{@api_url}/sendPhoto", params
    file.close
    file.unlink
  end

  def send_chat_action(chat_id, action = 'upload_photo')
    params = { chat_id: chat_id, action: action }
    post "#{@api_url}/sendChatAction", params
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

    def send_not_found(chat_id, reply_id)
      text = "Can't find photo :("
      params = { chat_id: chat_id, text: text }
      params[:reply_to_message_id] = reply_id unless reply_id.nil?
      post "#{@api_url}/sendMessage", params
    end
end
