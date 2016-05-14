class UsersController < ApplicationController
  before_action :authenticate_user!, only: [:show, :get_cards]
  def index
  end

  def show
  	unless current_user.cards.present?
  		redirect_to get_cards_user_url(current_user.id), notice: '好きなアカウントを5つ選択してください。'
  		return
  	end
  	@user = User.find(params[:id])
  	@cards = @user.cards
  	#@trend = google_trend('google','apple','yahoo','uber')
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

  	private
  	require "nokogiri"
	require "open-uri"
	require "cgi"
  	# w1, w2, w3, w4に関するトレンドの推移
  	def google_trend(w1, w2, w3, w4)
		# 検索結果を開く
  		doc = Nokogiri.HTML(open("http://www.google.com/trends/fetchComponent?hl=ja-JP&q=#{w1},#{w2},#{w3},#{w4}&cid=TIMESERIES_GRAPH_0&export=5&w=250&h=300"))
  		return doc
  	end
end
