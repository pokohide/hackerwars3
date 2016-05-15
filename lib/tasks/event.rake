namespace :event do
    desc "毎分実施。クロールしてトレンドがあれば問題を生成する"
    task create: :environment do
        trend_word = get_a_trend || 'google'

        # trend_wordでTweetを検索し、DBに登録
        # client = get_twitter_client
        # query = trend_word
        # puts query
        # result_tweets = client.search(query, count: 15, locale: "ja", result_type: "recent",  exclude: "retweets")
        # result_tweets.each_with_index do |tw, i|
        #   # puts "#{i}: #{tw.id}: @#{tw.user.screen_name}: #{tw.full_text}"
        #   tweet = Tweet.new({tweet_id: tw.id, name: tw.user.name, screen_name: tw.user.screen_name, full_text: tw.full_text})
        #   tweet.save
        # end

        event = Event.new
        event.trend_word = trend_word
        event.start_time = Time.zone.now
        event.end_time = event.start_time + 3.minutes
        event.save
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
            result.sort_by { |arr| arr[0] }.reverse

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
            # association = event.result.split(":")[1]
            # card_id = event.result.split(":")[2]
            # c = Card.find(card_id)
            # u = User.find(c.user_id)
            # binding.pry
            # u.score += association.to_i
            # u.save
            # binding.pry
        end
    end

    private

    def update_user id
        user = User.find(id)

    end

    # cardがuserに所有権限が映る
    def swap_card card user
        card.user_id = user.id
        card.save
    end

    # TwitterAPI
    def get_twitter_client
      client = Twitter::REST::Client.new do |config|
        config.consumer_key        = '8XDFefeCi9JKqW0nnJkJxV62c'
        config.consumer_secret     = 'ExyBu6FMWyp49xHwZFqXeUMcepDXND6dKHl16mdKoz2qnqK5Cz'
        config.access_token        = '3976234632-0kxLLEDxJKgDtyVjfVnETNQmjb53Pa4GlG7DUq0'
        config.access_token_secret = 'QQxoHgLhIpDjoo2ntckMR6KiHc9f6WITVtyCjD212rCxQ'
       end
      client
    end

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
