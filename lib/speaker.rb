class Speaker
  def initialize(api_key)
    @api_url = "https://api.telegram.org/bot#{api_key}"
  end

  def send_message(chat_id, text, reply_id = nil)
    params = { chat_id: chat_id, text: text }
    params[:reply_to_message_id] = reply_id unless reply_id.nil?
    headers = { content_type: :json, accept: :json }
    res = RestClient.post "#{@api_url}/sendMessage", params, headers
    p res
  end
end
