require 'sinatra'
require 'exifr'
require 'open-uri'
require 'pp'
get '/' do
  foto = open('http://24.media.tumblr.com/3bfe00f9d4933992a8e7e97f9878b13f/tumblr_mh8q7oN4BG1rianpko1_1280.jpg')
  exif = EXIFR::JPEG.new(foto)
  "#{exif.gps.latitude} #{exif.gps.longitude}"
end
