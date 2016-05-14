require "open-uri"

class Api::TrendController < ApplicationController

  def index
    trend = google_trend2[1]
    render json: {trend: trend}
  end

  def google_trend2
    arr = []
    # 検索結果を開く
    doc = Nokogiri.HTML(open("http://www.google.co.jp/trends/hottrends/atom/hourly"))
    doc.css('a').each do |anchor|
      arr.push(anchor.inner_text)
    end
    return arr
  end

end
