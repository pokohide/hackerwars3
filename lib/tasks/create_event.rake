namespace :event do
    desc "毎分実施。クロールしてトレンドがあれば問題を生成する"
    task create: :environment do
        trend_word = get_trend

        event = Event.new
        event.trend_word = trend_word
        
    end

    desc "答えの集計 #=> イベントのトレンドとその答えにきたユーザ名との相関が一番大きい順にソート"
    task aggregate: :environment do
        Event.where(finished: false).all.each do |event|
            w1 = event.trend_word
            result = []
            event.cards.each do |card|
                association = associate w1, card.name
                result << [association, card.id]
            end
            result.sort_by { |arr| arr[0] }

            "".tap do |str|
                result.each_with_index do |res, ind|
                    if ind == 0
                        str += "#{ind+1}:#{res[0]}:#{res[1]}"
                    else
                        str += ",#{ind+1}:#{res[0]}:#{res[1]}"
                    end
                    # 順位:相関度:カード番号
                end
                event.result = str
            end
            event.finished = true
            event.save
        end
    end

    private
    # トレンドのキーワードを取得
    def get_trend

    end

    # w1とw2の関連度を数値で返す
    def associate w1, w2
        require 'nokogiri'
        require 'open-uri'
        require 'cgi'

        key = "#{w1} #{w2}"
        escaped_key = CGI.escape(key)

        doc = Nokogiri.HTML( open("http://www.google.co.jp/search?ie=UTF-8&oe=UTF-8&q=#{escaped_key}") )
        str_of_number = doc.css('#resultStats').text
        number = str_of_number.delete!("約 ").delete!("件").delete!(",")
        return number.to_i
    end
end