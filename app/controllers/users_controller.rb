class UsersController < ApplicationController
  before_action :authenticate_user!, only: [:show, :get_cards]
  def index
  end

  def show
  	unless current_user.cards.present?
  		redirect_to get_cards_user_url(current_user.id), notice: '好きなアカウントを5つ選択してください。'
  		return
  	end

  end

  def get_cards
  	gon.user_id = current_user.id
  	@cards = Card.all
  end

  def post_cards
  	require 'csv'
  	@user = User.find(params[:id])
  	@card_ids = params[:ids]
  	@card_ids.parse_csv do |id|
  		evideo = Evideo.find(id)
  		evideo.user_id = @user.id
  		evideo.save
  	end
  	render nothing: true
  end
end
