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

  get '/' do
    get_quote
    haml :index, :format => :html5
  end

  get '/quote.json' do
    get_quote
    @quote.to_json
  end

  get '/css/:name.css' do
    sass params[:name].to_sym, :views => 'sass'
  end

  get '/js/:name.js' do
    coffee params[:name].to_sym, :views => 'coffee'
  end

  def get_quote
    @quote = Quotes::Quotedb.get
  end

end
