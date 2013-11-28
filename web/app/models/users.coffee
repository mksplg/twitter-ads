orm = require('orm')

module.exports = (db, callback) ->
	db.define("users", {
		id_str: String,
		screen_name: String,
		name: String,
		description: String,
		created_at: String,
		location: String,
		profile_image_url: String,
		profile_image_url_https: String,
		profile_text_color: String,
		url: String,
		listed_count: Number,
		favourites_count: Number,
		followers_count: Number,
		statuses_count: Number,
		friends_count: Number
	}, {
		id: 'id_str',
		validations: {
			screen_name: orm.validators.unique('screen_name not unique')
		}
	})

	return callback()
