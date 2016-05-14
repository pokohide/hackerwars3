# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$('.users.get_cards').ready ->
	card_num = 0
	max_num = 8
	card_ids = []
	card_srcs = []

	$('#card_count').text('0/8')
	$('.card_field').on 'click', ->
		src = $(this).find('img').attr('src')
		name = $(this).find('b').text()
		id = $(this).attr('data-id')

		return if (src in card_srcs) || card_num > max_num - 1
		
		card_num += 1
		card_srcs.push src
		card_ids.push id
		$('#card_count').text(card_num + '/' + max_num)
		add_card src, name

	add_card = (src, name) ->
		$li = $('<li class="have_card" style="width:100px;margin:0 8px"></li>')
		html = """
			<div class='thumbnail' style='margin-bottom:0'>
				<img src="#{src}" style='width:100%'>
			</div> 
			<div class='caption text-center'>
				<b>#{name}</b>
			</div>
		"""
		$li.html(html)
		$li.appendTo( $('ul.have_cards') ).fadeIn(500)

	$('#push_cards').on 'click', (e) ->
		e.preventDefault()
		push_cards card_ids if card_ids.length > 0

	push_cards = (ids) ->
		$("#loading").show()
		push_ids = ""
		for id,index in ids
			if index == 0
				push_ids += "#{id}"
			else
				push_ids += ",#{id}"

		console.log push_ids

		$.ajax(
			url: "/users/#{gon.user_id}/post_cards"
			async: true
			type: 'POST'
			data:
				ids: push_ids
			error: (jqXHR, textStatus, errorThrown) ->
				console.log errorThrown
				alert '登録に失敗しました。'
			success: (data, textStatus, jqXHR) ->
				window.location.href = "/users/#{gon.user_id}"
		)
		$("#loading").fadeOut(1000)


$('.users.show').ready ->

	# ajaxで最新イベントがあるかをポーリングする
	polling_recent_event = (event_id) ->
		$.ajax(
			url: "/poll_event/#{event_id}"
			async: true
			type: 'GET'
			error: (jqXHR, textStatus, errorThrown) ->
				alert '登録に失敗しました。'
			success: (data, textStatus, jqXHR) ->
				console.log data
				if data.id != window.event_id
					window.event_id = data.id
					window.answer_time = true
		)

	push_event_with_id = (event_id, card_id) ->
		$.ajax(
			url: "/push_event/#{event_id}/with/#{card_id}"
			async: true
			type: 'POST'
			error: (jqXHR, textStatus, errorThrown) ->
				alert '登録に失敗しました。'
			success: (data, textStatus, jqXHR) ->
				console.log data
		)

	# トレンドがtrendのイベントをポップアップする。時間も表示する。
	display_event = (trend) ->
		$event_board = $("<div class='jumbotron event_board'></div>")

		html = """
  			<button type="button" class="close" id="close_event" data-dismiss="modal" aria-hidden="true">×</button>
  			<br>
  			<p class="event_title">現在のトレンドは<b>#{trend}</b>です。</p>

  			<br>
  			<h5 class="explain">このトレンドと相関関係の高そうな手持ちのアカウントを選択して世界中のみんなのアカウントを奪い合ってください</h5>
		"""
		$event_board.html(html)
		$event_board.appendTo( $('body') ).fadeIn(500)

	dismiss_event = ->
		$('.event_board').hide()
		window.answer_time = false

	$(document).on 'click', '#close_event', ->
		dismiss_event()


	# このevent_idを更新していく。
	#window.event_id = gon.event_id
	window.event_id = 0
	window.answer_time = false

	#display_event('大統領選')


	# 5秒に一回サーバーにアクセスして、イベントが更新されているかを見る
	timer = setInterval ->
		clearInterval(timer) if false

		# event_idでアクセスしている。
		polling_recent_event(window.event_id)

	, 5000


	# リストのカードをクリックすると選択する
	$('.your_cards li').on 'click', ->
		$('.your_cards li.checked').removeClass('checked')
		$(this).addClass('checked')
