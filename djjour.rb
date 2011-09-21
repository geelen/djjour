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

p tracks.map { |t| t['Kind'] }.uniq

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
