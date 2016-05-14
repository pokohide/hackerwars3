module ApplicationHelper
	def alert_or_notice alert, notice
        return if !alert.present? && !notice.present?
        if alert
            type = "warning"
        elsif notice
            type = "success"
        end

        content_tag(:div, class: "alert alert-#{type}", style: "margin:10px 0px") do
            "<a href='#' class='close' data-dismiss='alert' aria-label='close'>&times;</a>"
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
end
