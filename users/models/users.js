exports.setup = function(db) {
	var User = db.define("user", {
		id: String,
		screen_name: String,
		name: String,
		profile_image_url: String,
		location: String,
		favourites_count: Number,
		url: String,
		lang: String,
		statuses_count: Number,
		friends_count: Number,
		followers_count: Number,
		}, {}
	);
};
