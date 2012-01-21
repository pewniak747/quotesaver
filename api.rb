# encoding: utf-8
require 'json'
require 'httparty'
require 'xmlsimple'

module Quotes
  class Base
    attr_reader :format, :url
    def get
      response = HTTParty.get(url).body
      if format == 'json' || url =~ /\.json$/
        JSON.parse(response)
      elsif format == 'xml' || url =~ /\.xml$/
        XmlSimple.xml_in(response)
      else response end
      rescue
        JSON.parse(File.read(File.join(File.dirname(__FILE__), 'quote.json')))
    end
  end

  class Quotedb < Base
    def initialize
      @format = 'xml'
      @url = 'http://www.quotedb.com/quote/quote.php?action=random_quote_rss'
    end

    def parse data={}
      return data if data['author'] && data['quote']
      ret = {}
      data = data['channel'][0]['item'][0]
      ret['author'] = data['title'][0].strip
      ret['quote'] = data['description'][0].gsub(/(^['"])|(['"]$)/, '').strip
      ret
    end

    def self.get
      fetcher = self.new
      quote = Hash.new('')
      quote = fetcher.parse(fetcher.get) while quote['quote'].size == 0 || quote['quote'].size > 160
      quote
    end
  end

  class Quotesondesign < Base
    def initialize
      @format = 'json'
      @url = 'http://quotesondesign.com/api/3.0/api-3.0.json'
    end

    def self.get
      self.new.get
    end
  end
end

