require 'sinatra'
require 'sinatra/json'

require_relative 'app'

use App
run Sinatra::Application
