var request = require('request');
var JSONStream = require('JSONStream');
var OAuth = require('oauth');
var orm = require("orm");

var keys = require('./keys.js');
var users = require('./models/users.js');
var stream = JSONStream.parse();

var userDb;
var bearerToken;

function setup(callback) {
	var dbOpts = {
		protocol: "sqlite",
		host: process.env.USERDB || '../data/users.sqlite'
	};

	orm.connect(dbOpts, function (err, db) {
		if (err) throw err;
		users.setup(db);
		db.sync(callback);
		userDb = db;
	});
}

function getBearerToken(callback) {
	var OAuth2 = OAuth.OAuth2;
	var oauth2 = new OAuth2(keys.consumer_key, keys.consumer_secret, 'https://api.twitter.com/', null, 'oauth2/token', null);
		oauth2.getOAuthAccessToken('', {'grant_type': 'client_credentials'}, function(e, access_token, refresh_token, results) {
			bearerToken = access_token;
			callback();
		}
	);
}

function requestUser(params) {
	var options = {
		url: "https://api.twitter.com/1.1/users/show.json",
		qs: params,
		headers: {
			'User-Agent': 'AIC Data Mining',
			Authorization: "Bearer " + bearerToken
		}
	};

	request(options).pipe(stream);

	stream.on('root', function(obj) {
		addUser(obj);
	});
}

function addUser(user) {
	userDb.models.user.create([user], function(err, items) {
			if (err) throw err;
			console.log(items);
			console.log(items[0].screen_name);
		});
}

setup(function(err) {
	getBearerToken(function() {
		var params = {screen_name: 'mksplg'};
		requestUser(params);
	});
});
