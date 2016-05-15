require 'twitter'
require "nokogiri"
require "open-uri"

namespace :twitter_api do
  desc "ツイート"
  task :get_tweets => :environment do
    client = get_twitter_client
    query = google_trend2[1]
    puts query
    result_tweets = client.search(query, count: 10, locale: "ja", result_type: "popular",  exclude: "retweets")
    result_tweets.each_with_index do |tw, i|
      puts "#{i}: #{tw.id}: @#{tw.user.screen_name}: #{tw.full_text}"
      tweet = Tweet.new({tweet_id: tw.id, name: tw.user.name, screen_name: tw.user.screen_name, full_text: tw.full_text})
      tweet.save
    end
  end
end

def get_twitter_client
  client = Twitter::REST::Client.new do |config|
    config.consumer_key        = '8XDFefeCi9JKqW0nnJkJxV62c'
    config.consumer_secret     = 'ExyBu6FMWyp49xHwZFqXeUMcepDXND6dKHl16mdKoz2qnqK5Cz'
    config.access_token        = '3976234632-0kxLLEDxJKgDtyVjfVnETNQmjb53Pa4GlG7DUq0'
    config.access_token_secret = 'QQxoHgLhIpDjoo2ntckMR6KiHc9f6WITVtyCjD212rCxQ'
   end
  client
end

def google_trend2
  arr = []
  # 検索結果を開く
  doc = Nokogiri.HTML(open("http://www.google.co.jp/trends/hottrends/atom/hourly"))
  doc.css('a').each do |anchor|
    arr.push(anchor.inner_text)
  end
  return arr

end
