class EventsController < ApplicationController
  # event_idにcard_idを登録する
  def pushed
  	event = Event.find_by(id: params[:id])
  	card = Card.find_by(id: params[:card_id])

  	# イベントの時間内なら登録する。時間外なら何も返さない
  	if Time.now < event.end_time
  		render text: "ok"
  	else
  		render text: "ng"
  	end
  end

  def polled # event_idにアクセスする
  	ex_id = params[:id]
  	now_id = Event.last.try(:id) || ex_id

  	# もし送られてきたex_idとnow_idが一緒なら新しいイベントは作られていない。
  	if ex_id == now_id
  		render json: "{id: #{now_id}}".to_json
  	else
  		event = Event.find_by(id: now_id)
  		trend = event.trend_word
  		render json: "{id: #{now_id}, trend: #{trend}}".to_json
  	end
  end
end
