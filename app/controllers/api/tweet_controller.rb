class Api::TweetController < ApplicationController
  def index
  	id = params[:id]
  	last_id = Tweet.last.id
  	if last_id == id
  		render json: {id: last_id}.to_json
  	else
	    tweets = Tweet.order(created_at: :desc).limit(20)
    	render json: {response: tweets, id: last_id}.to_json
    end
  end
end
