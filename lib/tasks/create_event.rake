namespace :recommend do
    desc "週に一回実行。ユーザの視聴履歴からオススメを算出する"
    task update: :environment do
        ids = Evideo.pluck(:id)
        max = ids.size

        for i in 0...max
            for j in (i+1)...max
                #puts "#{i}:#{j}"
                i_id = ids[i]
                j_id = ids[j]

                # ジャッカー度指数を計算
                join = (REDIS.sunion "e#{i_id}", "e#{j_id}").size
                intersect = (REDIS.sinter "e#{i_id}", "e#{j_id}").size
                if (join == 0 || intersect == 0)
                    next
                end

                jaccard = intersect / join
                if jaccard == 0
                    next
                end
                REDIS.zadd "Jaccard:Evideo#{i_id}", jaccard, "#{j_id}"
                REDIS.zadd "Jaccard:Evideo#{j_id}", jaccard, "#{i_id}"
            end
        end

    end
end

namespace :event do
    desc "毎分実施。クロールしてトレンドがあれば問題を生成する"
    task create: :environment do

    end

    desc "答えの集計"
    task aggregate: :environment do

    end
end