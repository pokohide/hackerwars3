class UsersController < ApplicationController
  before_action :authenticate_user!, only: [:show, :get_cards]
  def index
  end

  def show
  	unless current_user.cards.present?
  		redirect_to get_cards_user_url(current_user.id), notice: '好きなアカウントを5つ選択してください。'
  		return
  	end
  	@cards = current_user.cards
  	#@cards = current_user.cards.pluck(:id, :name, :screen_name, :tweets_count, :followers_count, :profile_image_url)
  end

  def get_cards
  	gon.user_id = current_user.id
  	@cards = Card.all
  	@cards = Card.group(:profile_image_url).all
  end

  def post_cards
  	require 'csv'
  	@user = User.find(params[:id])
  	@card_ids = params[:ids]
  	@card_ids.parse_csv do |card_id|
  		card = Card.find_by(card_id)
  		card.user_id = @user.id
  		card.save
  	end
  	render nothing: true
  end
end
