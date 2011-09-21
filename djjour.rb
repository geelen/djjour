#encoding: utf-8

require 'nokogiri'

n = Nokogiri::XML(File.read(File.expand_path("~/Music/iTunes/iTunes Music Library.xml")))

tracks_dict = n.xpath("*/dict/key[contains(text(), 'Tracks')]").first.next_element

tracks = tracks_dict.xpath("dict").map { |track|
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

tracks_by_id = tracks.inject({}) { |h,t| h[t['Track ID']] = t; h }

require 'sinatra'
require 'json'

get '/' do
  content_type :json
  {count: tracks.count, tracks: tracks}.to_json
end

get '/mp3' do
  content_type :json
  mp3 = tracks.select { |t| t['Kind'] == "MPEG audio file" }
  {count: mp3.count, tracks: mp3}.to_json
end

get '/aac' do
  content_type :json
  aac = tracks.select { |t| t['Kind'] =~ /AAC audio file/ }
  {count: aac.count, tracks: aac}.to_json
end

get '/track/:id' do
  content_type :json
  tracks_by_id[params[:id].to_i].to_json
end

get '/track/:id/file' do
  send_file URI.decode(tracks_by_id[params[:id].to_i]['Location'])[/file:\/\/localhost(.*)/,1]
end
