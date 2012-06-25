# encoding: utf-8
require 'ostruct'

class Quote < OpenStruct
  def tweet_url
    tweet = "\"#{content}\" - #{author}. http://quotes.pewniak747.info"
    if tweet.size <= 140
      'http://twitter.com?status=' + URI.encode(tweet)
    else nil
    end
  end

  def to_json
    {
      author: author,
      content: content
    }.to_json
  end
end
