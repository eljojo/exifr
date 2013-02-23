require 'sinatra/base'
require "sinatra/json"
require 'exifr'
require 'open-uri'
require 'andand'

class Exifr < Sinatra::Base
  helpers Sinatra::JSON
  
  def initialize
    super
    @cache = {}
  end
  
  get '/' do
    if (/https?:\/\/.+\.jpg/i).match(params_url) then
      json process_image
    else
      json error: "there's no jpeg and stuff", url: params_url
    end
  end
  
  private
    def params_url
      request.fullpath.slice(2, request.fullpath.length - 2)
    end

    def process_image
      return @cache[params_url] if @cache[params_url]
      exif = EXIFR::JPEG.new(open(params_url))
      @cache[params_url] = {
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
end
