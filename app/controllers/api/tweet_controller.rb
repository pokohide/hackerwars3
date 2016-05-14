class Api::TweetController < ApplicationController
  def index
    tweets = Tweet.order(created_at: :desc).limit(10)
    render json: tweets
  end
end
