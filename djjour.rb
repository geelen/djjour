#encoding: utf-8

require 'nokogiri'

n = Nokogiri::XML(File.read("/Volumes/Rodríguez/Music/iTunes/iTunes Music Library.xml"))

tracks_dict = n.xpath("*/dict/key[contains(text(), 'Tracks')]").first.next_element

tracks_hash = tracks_dict.xpath("dict").map { |track|
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

p tracks_hash.count
