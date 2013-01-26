require 'sinatra'
require "sinatra/json"
require 'exifr'
require 'open-uri'
require 'andand'

get '/' do
  foto = open('http://24.media.tumblr.com/3bfe00f9d4933992a8e7e97f9878b13f/tumblr_mh8q7oN4BG1rianpko1_1280.jpg')
  exif = EXIFR::JPEG.new(foto)
  result = {
    latitude:   exif.gps.andand.latitude || '',
    longitude:  exif.gps.andand.longitude || '',
    width:      exif.width || '',
    height:     exif.height || '',
    model:      exif.model || '',
    # date_time:  exif.date_time || '',
    exposure:   exif.exposure_time.to_s || '',
    f_number:   exif.f_number.to_f || '',
  }
  json result
end
