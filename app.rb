require 'sinatra'
require 'sinatra/reloader'
require 'sinatra/json'
require 'haml'
require 'dotenv'
require 'eth'
require 'mongo'
require_relative 'spotify'

class App < Sinatra::Base
  MANIFEST = {
    version: '1.0',
    name: 'Spotistyle',
    description: 'Returns your favorite music genres',
    homepage_url: ENV['HOMEPAGE_URL'] || 'http://localhost:8000',
    picture_url: ENV['PICTURE_URL'] || 'https://avatars1.githubusercontent.com/u/42174428?s=200&v=4',
    address: ENV['APP_ADDRESS'] || '0x88032398beab20017e61064af3c7c8bd38f4c968',
    app_url: ENV['APP_URL'] || 'http://localhost:8000/data',
    app_reward: 0,
    app_dependencies: []
  }.freeze

  configure do
    register Sinatra::Reloader
  end

  before do
    Dotenv.load
  end

  get '/' do
    haml :'index'
  end

  get '/login' do
    haml :'login'
  end

  get '/callback' do
    redirect "/sign?code=#{params[:code]}"
  end

  get '/sign' do
    haml :'sign'
  end

  post '/sign' do
    address = Eth::Utils.public_key_to_address(Eth::Key.personal_recover(params[:code], params[:signature]))
    access_token  = spotify.token(params[:code])
    genres        = spotify.genres(access_token)
    db.update_one({ _id: address.downcase }, { '$set': { genres: genres }}, { upsert: true })
    redirect '/done'
  end

  get '/done' do
    haml :'done'
  end

  get '/manifest' do
    json MANIFEST
  end

  get '/data' do
    address = Base64.decode64(request.env['HTTP_X_PERMISSION_SUBJECT']).to_s.downcase.gsub('"', '')
    obj = db.find({ _id: address }).first
    return status 404 if obj.nil?
    json obj['genres']
  end

  private

  def spotify
    Spotify.new(ENV['SPOTIFY_CLIENT_ID'], ENV['SPOTIFY_CLIENT_SECRET'], "#{request.env['rack.url_scheme']}://#{request.env['HTTP_HOST']}/callback")
  end

  def db
    Mongo::Logger.logger.level = ::Logger::INFO
    Mongo::Client.new(ENV['MONGO_URL'] || 'mongodb://localhost:27017/spotistyle')['genres']
  end
end
