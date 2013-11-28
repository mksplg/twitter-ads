mongoClient = require('mongodb').MongoClient

config = require('../../config/config')
collection = {}

connection = mongoClient.connect config.mongo_opts.connection, (err, db) ->
	if (err)
		return console.dir(err)
	collection = db.collection(config.mongo_opts.collection)

module.exports.getAdsForTopic = (topic, dataCallback, closeCallback) ->
	stream = collection.find({keywords: topic}).stream()
	stream.on('data', dataCallback)
	stream.on('close', closeCallback)
	return stream
