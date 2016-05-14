class UsersController < ApplicationController
  before_action :authenticate_user!, only: [:show, :get_cards]
  def index
  end

  def show
  	unless current_user.cards.present?
  		redirect_to get_cards_user_url(current_user.id)
  		return
  	end

  end

  def get_cards
  	@cards = Card.all
  end
end
