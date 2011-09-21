class DJjour::Client < Sinatra::Base
  set :port, 1337

  # runs once server is booted
  configure do
    DJjour::Bonjour.register
  end

  def mpeg?(t); t['Kind'] == "MPEG audio file" end
  def aac?(t); t['Kind'] =~ /AAC audio file/ end

  get '/' do
    content_type :json
    {count: tracks.count, tracks: tracks}.to_json
  end

  get '/mp3' do
    content_type :json
    mp3 = tracks.select(&method(:mpeg?))
    {count: mp3.count, tracks: mp3}.to_json
  end

  get '/aac' do
    content_type :json
    aac = tracks.select(&method(:mpeg?))
    {count: aac.count, tracks: aac}.to_json
  end

  get '/tracks/:id' do
    content_type :json
    tracks_by_id[params[:id].to_i].to_json
  end

  get '/tracks/:id/file' do
    track = tracks_by_id[params[:id].to_i]
    if mpeg?(track)
      content_type 'audio/mpeg'
    else
      content_type 'audio/aac'
    end

    send_file URI.decode(track['Location'])[/file:\/\/localhost(.*)/,1]
  end

  private

  def tracks_by_id
    @tracks_by_id ||= tracks.inject({}) { |h,t| h[t['Track ID']] = t; h }
  end

  def tracks
    @tracks||= tracks_dict.xpath("dict").map { |track|
      h = {}
      track.elements.each_slice(2) do |key, val|
        raise "WATKEY #{key}" if key.name != 'key'
        h[key.text] = case val.name
          when 'integer'
            val.text.to_i
          when 'string'
            val.text
          when 'date'
            val.text
          when 'true'
            true
          when 'false'
            true
          else
            raise "WATVAL #{val}"
        end
      end
      h
    }
  end

  def tracks_dict
    @tracks_dict ||= document.xpath("*/dict/key[contains(text(), 'Tracks')]").first.next_element
  end

  def document
    @document ||= Nokogiri::XML(File.read(File.expand_path("~/Music/iTunes/iTunes Music Library.xml")))
  end
end
