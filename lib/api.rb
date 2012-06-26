# encoding: utf-8
require 'json'
require 'httparty'
require 'xmlsimple'
require 'redis'

module Quotes
  class Bookshelf
    def self.redis
      @redis ||= Redis.new
    end
    def self.get
      key = redis.keys("quotes:*").sample.match(/^quotes:(.*)$/)[1]
      fetch(key)
    end

    def self.fetch key
      keys = redis.hgetall("quotes:#{key}")
      Quote.new(keys.merge(key: key))
    end

    def self.put quote
      keys = quote.as_json.except(:key).to_a.flatten
      redis.hmset("quotes:#{quote.key}", *keys)
      redis.save
    end
  end

  class Quotedb
    include HTTParty
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

