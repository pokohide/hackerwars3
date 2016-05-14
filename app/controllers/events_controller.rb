class EventsController < ApplicationController
  # event_idにcard_idを登録する
  def pushed
  	event = Event.find_by(id: params[:id])
  	card = Card.find_by(id: params[:card_id])

  	# イベントの時間内なら登録する。時間外なら何も返さない
  	if Time.now < event.created_at + 3.minutes
  		card.event_id = event.id
  		card.save
  		render text: "ok"
  	else
  		render text: "ng"
  	end
  end

  def polled # event_idにアクセスする
  	ex_id = params[:id]
  	now_id = Event.last.try(:id) || ex_id
  	event = Event.find_by(id: now_id)
  	count = event.try(:cards).try(:count) || 0

  	# もし送られてきたex_idとnow_idが一緒なら新しいイベントは作られていない。
  	if ex_id == now_id
  		data = {id: now_id, number: count}
  		render json: data.to_json
  	else
  		trend = event.try(:trend_word)
  		data = {id: now_id, trend: trend, number: count}
  		render json: data.to_json
  	end
  end

  # 過去のイベント一覧
  def result
  	@events = Event.order('id desc').all
  end

end
