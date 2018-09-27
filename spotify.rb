require 'faraday'
require 'base64'
require 'json'
require 'byebug'

class Spotify
  def initialize(client_id, client_secret, redirect_uri)
    @client_id     = client_id
    @client_secret = client_secret
    @redirect_uri  = redirect_uri
  end

  def genres(access_token)
    response = request do
      connection('https://api.spotify.com').get('/v1/me/top/artists?limit=50') do |request|
        request.headers['Authorization'] = "Bearer #{access_token}"
      end
    end

    list = response['items'].map { |artist| artist['genres'] }.flatten
    list.each_with_object(Hash.new(0)) { |word,counts| counts[word] += 1 }.map { |k,v| [k, v] }.sort_by { |g| g[1] }.reverse.first(10).map { |g| g.first }
  end

  def token(code)
    response = request do
      connection('https://accounts.spotify.com').post('/api/token') do |request|
        request.params = {
          grant_type:    'authorization_code',
          code:          code,
          redirect_uri:  @redirect_uri,
          client_id:     @client_id,
          client_secret: @client_secret
        }
      end
    end

    raise response['error_description'] if response['error']
    response['access_token']
  end

  private

  def connection(url)
    Faraday.new(url: url)
  end

  def authorization_header
    "Basic #{@client_id}:#{@client_secret}"
  end

  def request
    response = yield.body
    JSON.parse(response)
  end
end
