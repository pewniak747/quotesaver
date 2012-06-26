# encoding: utf-8
require 'active_support/all'
require 'ostruct'

class Quote < OpenStruct
  def initialize opts
    super
    set_key
  end

  def tweet_url
    tweet = "\"#{content}\" - #{author}. http://quotes.pewniak747.info/#{key}"
    if tweet.size <= 140
      'http://twitter.com?status=' + URI.encode(tweet)
    else nil
    end
  end

  def to_json
    as_json.to_json
  end

  def as_json
    {
      author: author,
      content: content,
      key: key,
      tweet_url: tweet_url
    }
  end

  private
  def set_key
    self.key ||= SecureRandom.hex(8)
  end
end
