module ApplicationHelper
	def alert_or_notice alert, notice
        return if !alert.present? && !notice.present?
        if alert
            type = "warning"
        elsif notice
            type = "success"
        end

        content_tag(:div, class: "alert alert-#{type}", style: "margin:10px 0px;position:absolute;top:20px;z-index:10;width:100%") do
            alert || notice
        end
    end

    def thumbnail source, options = {}
        if source.instance_of?(String)
            source.sub!(/http:\/\//) { "https://" }
        end
        options['data-original'] = source
        if options[:class].blank?
            options[:class] = "user-thumbnail lazy"
        else
            options[:class] = options[:class].to_s + " user-thumbnail lazy"
        end
        image_tag 'user.png', options
    end

    def winning_percentage win, lose
				if win.zero? && lose.zero? then
						return 0
				end
        ret = ( 1 - win/(win + lose).to_f ) * 100
        ret.present? ? ret : 0
    end
end
