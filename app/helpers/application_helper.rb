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
end
