class Event < ActiveRecord::Base

	has_many :cards

	# resultを解析して結果をランキング形式で配列で返す。
	require 'csv'
	def ranking
		ranks = []
		return ranks unless finished
		result.parse_csv.each do |res|
			if /(\d+):(\d+):(\d+)/ =~ res
				rank = $1.to_i
				association = $2.to_i
				card_id = $3.to_i

				ranks.push [rank, association, card_id]
			end
		end
		ranks
	end
end
