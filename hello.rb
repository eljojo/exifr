require 'sinatra'
require "sinatra/json"
require 'exifr'
require 'open-uri'
require 'andand'

get '/' do
  if (/https?:\/\/.+\.jpg/i).match(params_url) then
    json process_image
  else
    json error: "there's no jpeg and stuff", url: params_url
  end
end

def params_url
  request.fullpath.slice(2, request.fullpath.length - 2)
end

def process_image
  exif = EXIFR::JPEG.new(open(params_url))
  {
    width:      exif.width || '',
    height:     exif.height || '',
    model:      exif.model || '',
    # date_time:  exif.date_time || '',
    exposure:   exif.exposure_time.to_s || '',
    f_number:   exif.f_number.to_f || '',
    gps: {
      latitude:   exif.gps.andand.latitude || '',
      longitude:  exif.gps.andand.longitude || '',
    }
  }
end
