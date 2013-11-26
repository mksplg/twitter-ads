module.exports = (db, callback) ->
	db.define("user",
	{
		id_str: String,
		screen_name: String,
		name: String,
		profile_image_url: String,
		location: String,
		favourites_count: Number,
		url: String,
		lang: String,
		statuses_count: Number,
		friends_count: Number,
		followers_count: Number
	})

	return callback()
