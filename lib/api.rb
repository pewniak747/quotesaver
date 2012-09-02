# encoding: utf-8
require 'json'
require 'httparty'
require 'xmlsimple'
require 'yaml'

module Quotes
  class Bookshelf
    def self.all
      @quotes ||= YAML.load(File.open('db/quotes.yml'))
    end
    def self.get
      key = all.sample['key']
      fetch(key)
    end

    def self.fetch key
      keys = all.find{ |q| q['key'].to_s == key.to_s }
      Quote.new(keys)
    end
  end
end

