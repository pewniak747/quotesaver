# encoding: utf-8
require 'json'
require 'httparty'
require 'xmlsimple'

module Quotes
  class Base
    include HTTParty
  end

  class Quotedb < Base
    base_uri 'http://www.quotedb.com/quote/quote.php?action=random_quote_rss'

    def self.parse data
      data = XmlSimple.xml_in(data.body)['channel'][0]['item'][0]
      Quote.new.tap do |q|
        q.author = data['title'][0].strip
        q.content = data['description'][0].gsub(/(^['"])|(['"]$)/, '').strip
      end
    end

    def self.get
      response = super('')
      parse(response)
    end
  end
end

