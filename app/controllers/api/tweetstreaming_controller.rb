class Api::TweetstreamingController < ApplicationController
  def index
    count = 0
    tweets = []
    TweetStream::Client.new.sample do |tweet|
      puts count
      tweets << tweet
      puts tweets
      count += 1
      if count >= 10 then
        break
      end
    end
    render json: tweets
  end
end
