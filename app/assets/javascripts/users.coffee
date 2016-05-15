# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$('.users.get_cards').ready ->
	card_num = 0
	max_num = 5
	card_ids = []
	card_srcs = []

	$('#card_count').text("#{card_num}/#{max_num}")
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

				if data.id != window.event_id && $('body').hasClass('show')
					window.event_id = data.id
					window.answer_time = true
					display_event(data.trend, data.id, data.number)
				else
					refresh_event(data.id, data.number)
		)

	push_event_with_id = (event_id, card_id) ->
		$("#loading").show()
		$.ajax(
			url: "/push_event/#{event_id}/with/#{card_id}"
			async: true
			type: 'POST'
			error: (jqXHR, textStatus, errorThrown) ->
				alert '登録に失敗しました。'
			success: (data, textStatus, jqXHR) ->
				console.log data
				if data.response == 'ok'
					window.post_event_id = event_id
					window.post_card_id = card_id
					window.create_polling_time()
		)
		$("#loading").fadeOut(1000)

	# トレンドがtrendのイベントをポップアップする。時間も表示する。
	display_event = (trend, id, num) ->
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

		$event = $("<li class='event-#{id}'></li>")
		html = """
			<div class="well well-sm">
				<h5>トレンドは<b>#{trend}</b>です。</h5>
				<p>参加人数は#{num}人です。</p>
			</div>
		"""
		$event.html(html)
		$event.prependTo( $('ul.events') ).fadeIn(500)


	display_result = (rank, rankings) ->
		## SweetAlertを出して、順位とランキングを表示。左上のイベントにも追加する。
		$table = $("<table class='table table-stripped'></table>")
		html = "<table class='table table-stripped'><thead><th width='50'><tr>順位</tr><tr width='60'>トレンドとの相関度</tr><tr>カード名</tr></th></thead><tbody>"
		for ranking, index in rankings
			html += "<th><td>#{index + 1}</td><td>#{ranking.association}</td><td>#{ranking.card_name}</td></th>"
		html += "</tbody></table>"
		## あなたは何位でした。まるまるのカードは失いました。
		## rankで場合分け
		swal(
			html: $("<div class='jumbotron'></div>").html("<h3>あなたの順位は<b>#{rank}</b>です。</h3>#{html}")
			timer: 5000
			confirmButtonColor: '#FFB74D'
			showConfirmButton: false
			type: 'success'
		)
		$event = $("<li></li>")
		html = "<div class='well well-sm'><h5><b>#{trend}</b>のトレンドバトルの結果です。</h5>#{html}</div>"
		$event.html(html)
		$event.prependTo( $('ul.events') ).fadeIn(500)


	# イベントIDと参加者
	refresh_event = (id, number) ->
		$(".events li.event-#{id}").find("参加人数は#{number}人です")

	dismiss_event = ->
		$('.event_board').hide()
		window.answer_time = false

	$(document).on 'click', '#close_event', ->
		dismiss_event()

	# イベントに登録した時に呼び出される。登録時にそのイベントの集計結果を待つpolling_timeを設定
	window.create_polling_time = ->
		window.waiting_for_result = true
		result_timer = setInterval ->
			clearInterval(result_timer) unless window.waiting_for_result
			polling_result(window.post_event_id, window.post_card_id)
		, 5000

	# 集計結果を監視するポーリング
	polling_result = (event_id, card_id) ->
		$.ajax(
			url: "/poll_result/#{event_id}/with/#{card_id}"
			async: true
			type: 'GET'
			dataType: 'json'
			error: (jqXHR, textStatus, errorThrown) ->
				alert 'ポーリングに失敗しました。'
			success: (data, textStatus, jqXHR) ->
				console.log data
				return if data.response == 'ng'
				window.waiting_for_result = false
				display_result(data.rank, data.ranking)
		)

	# tweetをapiを叩いて読み込む
	fetch_tweet = ->
		$.ajax(
			url: '/api/tweet'
			async: true
			type: 'GET'
			dataType: 'json'
			error: (jqXHR, textStatus, errorThrown) ->
				alert '登録に失敗しました。'
			success: (data, textStatus, jqXHR) ->
				console.log data
				return if window.tweet_id == data.id
				window.tweet_id = data.id
				for tweet, index in data.response
					insert_tweet(tweet, index)
		)
	fetch_tweet()

	insert_tweet = (tweet, index) ->
		$tweet = $("<li class='tweet' style='margin-bottom:4px;'></li>")
		html = """
		<div class="well well-sm">
			<p><b class="name">#{tweet.name}</b> @ #{tweet.screen_name}</p>
			<div class="text">
				#{tweet.full_text}
			</div>
		</div>
		"""
		$tweet.html(html)
		$tweet.hide()
		setTimeout ->
			$tweet.prependTo( $('ul.tweets') ).fadeIn(500)
		, 500 * index

	# このevent_idを更新していく。
	window.event_id = gon.event_id
	window.tweet_id = 0
	window.answer_time = false

	# 5秒に一回サーバーにアクセスして、イベントが更新されているかを見る
	timer = setInterval ->
		clearInterval(timer) if false || !$('body').hasClass('show')
		# event_idでアクセスしている。
		polling_recent_event(window.event_id)
	, 5000

	# リストのカードをクリックすると選択する
	$('.users.show .your_cards li').on 'click', ->
		$('.your_cards li.checked').removeClass('checked')
		$(this).addClass('checked')


	$('.users.show .use_this_card').on 'click', (e) ->
		e.preventDefault()
		unless window.answer_time
			alert 'まだトレンドは発表されていません。'
			return
		if $('.your_cards li.checked').size == 0
			alert 'カードを選択してください。'
			return

		card_id = parseInt $('.your_cards li.checked').attr('data-id'), 10
		# 選択したカードをイベントに登録する
		push_event_with_id(window.event_id, card_id)
		dismiss_event()
