namespace :event do
    desc "毎分実施。クロールしてトレンドがあれば問題を生成する"
    task create: :environment do
        trend_word = get_a_trend || 'google'

        event = Event.new
        event.trend_word = trend_word
        event.start_time = Time.zone.now
        event.end_time = event.start_time + 3.minutes
        event.save
    end

    task now: :environment do
        puts Time.now
        puts Time.zone.now
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
    def get_a_trend
        require "open-uri"
        return get_trends[rand(10)]
    end

    def get_trends
        trends = []
        # 検索結果を開く
        doc = Nokogiri.HTML(open("http://www.google.co.jp/trends/hottrends/atom/hourly"))
        doc.css('a').each do |anchor|
            trends.push(anchor.inner_text)
        end
        return trends    
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