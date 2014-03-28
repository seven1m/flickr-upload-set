require 'bundler'
Bundler.require
require 'fileutils'

begin
  require_relative('./config')
rescue LoadError
  raise 'You must create config.rb'
end

if API_KEY.empty? or SECRET.empty? or USER_ID.empty?
  raise 'You must create config.rb'
end

flickr = FlickrParty.new(API_KEY, SECRET)

enable :sessions
set :session_secret, SESSION_SECRET

class Browser
  FLICKR_BATCH_SIZE = 10
  GRACE_PERIOD = 60 * 60 * 24 * 365 # 1 year
  DEFAULT_PATH = '/'

  attr_reader :path

  def initialize(path, flickr)
    @path = path || DEFAULT_PATH
    @flickr = flickr
    @by_name = {}
  end

  def root?
    @path == '/'
  end

  def parent_directory
    File.dirname(@path)
  end

  def directories
    Dir[File.join(@path, '*')].select { |p| File.directory?(p) }.sort
  end

  def filenames
    @filenames ||= Dir[File.join(@path, '*')].to_a.select { |p| p =~ /\.jpg$/i }.sort
  end

  def any_photos?
    filenames.any?
  end

  def photos_by_name
    @photos ||= filenames.each_with_object({}) do |path, hash|
      name = path.split('/').last.split('.').first.downcase
      hash[name] = {
        name: name,
        path: path,
        exif: EXIFR::JPEG.new(path)
      }
    end
  end

  def photos
    @photos ||= begin
      by_name = photos_by_name.dup
      photos_by_name.keys.each_slice(FLICKR_BATCH_SIZE) do |names|
        response = @flickr.flickr.photos.search(user_id: USER_ID, text: names.join(' or '), extras: 'date_upload,date_taken,url_s,url_o')
        if results = response['photos']
          [results].flatten.each do |found|
            name = found['title'].split('.').first.downcase
            date = Time.parse(found['datetaken'])
            if photo = by_name[name]
              diff = (photo[:exif].date_time - date).abs rescue nil
              if not diff or diff < GRACE_PERIOD
                photo[:flickr] = found
              end
            end
          end
        end
      end
      by_name.values
    end
  end
end

get '/' do
  redirect '/auth' unless session[:auth]
  @browser = Browser.new(params[:path], flickr)
  haml :browse
end

get '/auth' do
  redirect flickr.auth_url
end

get '/auth-complete' do
  session[:auth] = flickr.complete_auth(params[:frob])
  redirect '/'
end

get '/pic' do
  size = params[:size] || '75x75'
  content_type 'image/jpeg'
  if request.env['HTTP_IF_MODIFIED_SINCE']
    status 304
  else
    expires 60 * 60 * 24 * 30 # 30 days
    image = MiniMagick::Image.open(params[:path])
    image.resize "#{size}^"
    image.extent size
    image.to_blob
  end
end
