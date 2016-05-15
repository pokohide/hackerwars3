class Event < ActiveRecord::Base

	has_many :cards

	# resultを解析して結果をランキング形式で配列で返す。
	require 'csv'
	def ranking your_card_id
		ranks = []
		your_rank = 0
		return ranks unless finished
		result.parse_csv.each do |res|
			if /(\d+):(\d+):(\d+)/ =~ res
				rank = $1.to_i
				association = $2.to_i
				card_id = $3.to_i
				your_rank = rank if your_card_id == card_id
				card_name = Card.find(card_id).name
				ranks.push( {association: association, card_id: card_id, card_name: card_name} )
			end
		end
		return your_rank, ranks
	end
end
