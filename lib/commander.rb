class Commander
  COMMANDS = [
    C_START = 'start',
    C_HELP = 'help',
    C_SEARCH = 'search',
    C_BIG = 'big'
  ]

  def initialize(speaker, five_hundred_pixels)
    @speaker = speaker
    @fhp = five_hundred_pixels
  end

  def process(update)
    params = {
      text: update['message']['text'],
      chat_id: update['message']['chat']['id'],
      reply_id: update['message']['message_id']
    }
    return if params[:text].nil? || params[:text][0] != '/'
    params[:arguments] = params[:text][1..-1].split(' ')
    command = params[:arguments].shift
    params[:arguments] = params[:arguments].join ' '
    self.send command, params if COMMANDS.include? command
  end

  def start(params)
    text = ''
    text += "Hi! I will find beautifull photo for you.\n\n"
    text += "/help - Display this message\n"
    text += "/search <term> - Find photo\n"
    text += "/big <term> - Find uncropped photo\n"
    @speaker.send_message params[:chat_id], text
  end

  def help(params)
    start params
  end

  def search(params)
    if params[:arguments].empty?
    else
      @speaker.send_chat_action params[:chat_id]
      photo = @fhp.search params[:arguments]
      @speaker.send_photo params[:chat_id], photo, params[:reply_id]
    end
  end

  def big(params)
    if params[:arguments].empty?
    else
      @speaker.send_chat_action params[:chat_id]
      photo = @fhp.search params[:arguments], 4
      @speaker.send_photo params[:chat_id], photo, params[:reply_id]
    end
  end
end
