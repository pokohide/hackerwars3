class Api::TweetController < ApplicationController
  def index
    tweets = Tweet.order(created_at: :desc).limit(20)
    render json: tweets
  end
end
