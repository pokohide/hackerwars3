class EventsController < ApplicationController
  def pushed
  	ex_id = paramd[:id]
  	now_id = Event.last.try(:id) || ex_id

  	# もし送られてきたex_idとnow_idが一緒なら新しいイベントは作られていない。
  	if ex_id == now_id
  		render "{id: #{now_id}}".to_json
  	else
  		event = Event.find_by(id: now_id)
  		trend - event.trend_word
  		render "{id: #{now_id}, trend: #{trend}}".to_json
  	end
  end

  def pulled
  end
end
