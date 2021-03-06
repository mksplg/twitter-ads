_ = require('lodash')
ResponseObject = require('../libs/responseobject')
ErrorObject = require('../libs/errorobject')
tweets = require('../models/tweets')
ads = require('../models/ads')

###*
	** @api {get} /topics/:topic Get user
	* @apiVersion 0.0.1
	* @apiName get
	*
	* @apiDescription Get one topic
	*
	* @apiParam {String} name Topic
	*
	* @apiSuccess {Array}	result	requested data
	*	@apiExample Example usage:
	*		curl -X GET -H Content-Type: application/json"  http://localhost/topics/education
	*
	* @apiSuccessExample Success-Response:
	*     HTTP/1.1 200 OK
	*     {
	*       "result": [{"id" : 1, "name": "apple"}]
	*     }
	*
	* @apiError NoData The given ID is invalid
###
exports.get = (request, response) ->
	tweets.getUsersForTopic request.params.topic, (err, results) ->
		if err
			console.log err
		topic = {
			text: request.params.topic,
			users: results
		}
		object = new ResponseObject(topic)
		response.json object

exports.getAds = (request, response) ->
	topic = {
		text: request.params.topic,
		ads: []
	}

	ads.getAdsForTopic request.params.topic, (result) ->
		topic.ads.push result
	, () ->
		object = new ResponseObject(topic)
		response.json object
	
