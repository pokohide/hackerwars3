require 'twitter'

namespace :twitter_streaming do
  desc "ツイート"
  task :get_tweets => :environment do
    client = get_twitter_client
    query = "東京"
    result_tweets = client.search(query, count: 10, result_type: "popular",  exclude: "retweets")
    result_tweets.each_with_index do |tw, i|
      puts "#{i}: @#{tw.user.screen_name}: #{tw.full_text}"
      # TweetMongo.create!(data: tweet.to_json) 
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
