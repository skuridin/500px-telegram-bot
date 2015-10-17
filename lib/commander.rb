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
      reply_id: update['message']['message_id'],
      reply_text: update['message']['reply_to_message']
    }

    return if params[:text].nil?

    if params[:text][0] == '/'
      params[:arguments] = params[:text][1..-1].split(' ')
      command = params[:arguments].shift
      command = command.split('@')[0]
      params[:arguments] = params[:arguments].join ' '
    elsif !params[:reply_text].nil?
      command = params[:reply_text]['text'].split(':')[0].downcase
      params[:arguments] = params[:text]
    end

    if !params[:arguments].nil? && !params[:arguments].empty?
      user = update['message']['from']
      name = user['first_name']
      name += " @#{user['username']}" if !user['username'].empty?
      name += " #{user['last_name']}" if !user['last_name'].empty?
      puts "#{name} asks for \"#{params[:arguments]}\""
    end

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
      text = 'Search: What photo are you looking for?'
      @speaker.send_message params[:chat_id], text, params[:reply_id], true
    else
      @speaker.send_chat_action params[:chat_id]
      photo = @fhp.search params[:arguments]
      @speaker.send_photo params[:chat_id], photo, params[:reply_id]
    end
  end

  def big(params)
    if params[:arguments].empty?
      text = 'Big: What photo are you looking for?'
      @speaker.send_message params[:chat_id], text, params[:reply_id], true
    else
      @speaker.send_chat_action params[:chat_id]
      photo = @fhp.search params[:arguments], 4
      @speaker.send_photo params[:chat_id], photo, params[:reply_id]
    end
  end
end
