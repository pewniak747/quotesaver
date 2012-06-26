# encoding: utf-8

require 'sinatra'
require 'sinatra/reloader'
require 'haml'
require 'sass'
require 'coffee-script'
require 'uri'
require_relative './lib/api.rb'
require_relative './lib/quote.rb'

class QuoteSaver < Sinatra::Base
  ADAPTER = Quotes::Bookshelf

  get '/' do
    get_random_quote
    redirect "/#{@quote.key}"
  end

  get '/quotes.json' do
    get_random_quote
    @quote.to_json
  end

  get '/:key' do
    @quote = ADAPTER.fetch(params[:key])
    haml :index, :format => :html5
  end

  # assets
  get '/css/:name.css' do
    sass params[:name].to_sym, :views => 'sass'
  end

  get '/js/:name.js' do
    coffee params[:name].to_sym, :views => 'coffee'
  end

  private
  def get_random_quote
    @quote = ADAPTER.get
  end
end
