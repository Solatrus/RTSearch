apikey = "q4a7xvz983xr4jrgnhm34ezq"
baseUrl = "http://api.rottentomatoes.com/api/public/v1.0"
moviesUrl = "#{baseUrl}/movies.json?apikey="

searchResponse = (response) ->
	list = $ "#results"
	list.removeClass("empty").empty()
	if response.movies.length is 0
		list.addClass("empty")
		return true

	for movie in response.movies
		if movie.abridged_cast.length == 1
			cast = "#{movie.abridged_cast[0].name}"
		else if movie.abridged_cast.length >= 2
			cast = "#{movie.abridged_cast[0].name}, #{movie.abridged_cast[1].name}"

		title = movie.title
		if title.length > 20
			titleDisplay = movie.title.substring(0,20) + "..."
		else
			titleDisplay = title

		list.append """
		<a href="#{movie.links.alternate}">
			<div class="result" title="#{title}">
				<div class="left"><img class="thumbnail" src="#{movie.posters.thumbnail}"></div>
				<div class="right">
					<span class="title">#{titleDisplay} (#{movie.year})<br />
					<span class="cast">#{cast}<span>
				</div>
			</div>
		</a>
		"""

	return

$ ->
	timer = 0

	$("#search").on "keyup", (evt) ->
		text = $(@).text()

		if not text? or text.length < 4
			$("#results").addClass("empty").empty()
			return true

		if timer
			clearTimeout timer

		timer = setTimeout ->
			encodedQuery = encodeURIComponent text
			$.ajax
				url: "#{moviesUrl + apikey}&q=#{encodedQuery}"
				dataType: "jsonp"
				success: searchResponse

			return
		,400
		return

	$("#search").on "blur", ->
		$("#results").stop().slideUp(400)

	$("#search").on "focus", ->
		$("#results").stop().slideDown(400)