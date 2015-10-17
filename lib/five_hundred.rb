class FiveHundred
  def initialize(api_key)
    @api_key = api_key
    @api_url = 'https://api.500px.com/v1'
  end

  def search(term, size = 440)
    url = "#{@api_url}/photos/search"
    params = { consumer_key: @api_key, term: term, image_size: size, rpp: 5 }
    res = RestClient.get url, { accept: :json, params: params }
    photos = JSON.parse(res)['photos']
    return if photos.length == 0
    photo = photos[rand photos.length]['images'][0]
    download photo
  end

  protected
    def download(photo)
      in_file = open photo['url']
      out_file = Tempfile.new [File.basename(in_file), ".#{photo['format']}"]
      out_file.write in_file.read
      out_file.seek(0)
      out_file
    end
end
