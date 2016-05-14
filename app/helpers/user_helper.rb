module UserHelper

	def card_thumbnail url, options={}
		url.sub!('_normal', '_bigger')
        options['data-original'] = url
        if options[:class].blank?
            options[:class] = "lazy"
        else
            options[:class] = options[:class].to_s + "lazy"
        end
		image_tag url, options
	end
end
