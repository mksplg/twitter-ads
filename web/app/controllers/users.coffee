_ = require('lodash')
ResponseObject = require('../libs/responseobject')
ErrorObject = require('../libs/errorobject')
tweets = require('../models/tweets')


###*
	** @api {get} /users/ Get all users
	* @apiVersion 0.0.1
	* @apiName getAll
	*
	*
	* @apiDescription Get all users
	*
	* @apiSuccess {Array}	result requested data
	*
	* @apiExample Example usage:
	*		curl -X GET -H Content-Type: application/json"  http://localhost/users/
	*
	* @apiSuccessExample Success-Response:
	*     HTTP/1.1 200 OK
	*     {
	*       result: [
	*         {"id" : 1, "name":"apple"},
	*         {"id" : 2, "name":"banana"}
	*       ]
	*     }
	*
	* @apiError NoData No data available
	* @apiErrorExample Response (example):
	*     HTTP/1.1 400 Bad Request
	*     {
	*       "error": "NoData"
	*     }
###
exports.getAll = (request, response) ->
	request.models.users.find (err, rows) ->
		if err
			console.log err
			object = new ErrorObject('NoData')
			response.statusCode = 400
			return response.json object
		console.log 'user found'
		object = new ResponseObject(rows)
		response.json object

###*
	** @api {get} /users/:name Get user
	* @apiVersion 0.0.1
	* @apiName get
	*
	* @apiDescription Get one user
	*
	* @apiParam {String} name Screen name of the user
	*
	* @apiSuccess {Array}	result	requested data
	*	@apiExample Example usage:
	*		curl -X GET -H Content-Type: application/json"  http://localhost/users/user
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
	request.models.users.find {screen_name: request.params.name}, (err, items) ->
		if err
			object = new ErrorObject('NoData')
			response.statusCode = 400
			return response.json object
		object = new ResponseObject(items)
		response.json object

###*
	** @api {post} /users/ Create user
	* @apiVersion 0.0.1
	* @apiName	post
	*
	* @apiDescription	Create one user
	*
	* @apiParam	{String}	name name of the user
	*
	* @apiSuccess	{Array}	result	created user
	*
	* @apiExample Example usage:
	*		curl -X POST -H "Content-Type: application/json" -d '{"name":"coconut"}' http://localhost/users/
	*
	* @apiSuccessExample Success-Response:
	*     HTTP/1.1 200 OK
	*     {
	*       "result": [{"id" : 3, "name" : "coconut"}]
	*     }
	*
	* @apiError	InvalidParamsName	The given name is invalid
	* @apiErrorExample Response (example):
	*     HTTP/1.1 400 Bad Request
	*     {
	*       "error": "InvalidParamsName"
	*     }
###
exports.post = (request, response) ->
	unless request.body.hasOwnProperty("screen_name")
		object = new ErrorObject('InvalidParamsName')
		response.statusCode = 400
		return response.json object

	request.models.users.create request.body, (err, items) ->
		if err
			object = new ErrorObject('InvalidParams')
			response.statusCode = 400
			return response.json object
		object = new ResponseObject(items)
		response.json object

###*
	** @api {put} /users/:id Update user
	* @apiVersion 0.0.1
	* @apiName put
	*
	* @apiDescription Update one user
	*
	* @apiParam {Number}	id	id of the user
	* @apiParam {String}	name	name of the user
	*
	* @apiSuccess {Array}	result	updated user
	* @apiExample Example usage:
	*		curl -X PUT -H "Content-Type: application/json" -d '{"name":"pear"}' http://localhost/users/3
	*
	* @apiSuccessExample Success-Response:
	*     HTTP/1.1 200 OK
	*     {
	*       "result": [{"id" : 3, "name" : "pear"}}]
	*     }
	*
	*
	* @apiError InvalidParamsName The given name is invalid
	* @apiError InvalidParamsId The given ID is invalid
###
# exports.put = (request, response) ->
# 	id = parseInt(request.params.id)
# 	unless request.body.hasOwnProperty("user")
# 		object = new ErrorObject('InvalidParamsName')
# 		response.statusCode = 400
# 		return response.json object
# 	if _.isNaN(id)
# 		object = new ErrorObject('InvalidParamsId')
# 		response.statusCode = 400
# 		return response.json object
# 	users.update(id, request.body.user)
# 	object = new ResponseObject(users.get(id))
# 	response.json object

###*
	** @api {delete} /users/:id Delete user
	* @apiVersion 0.0.1
	* @apiName delete
	*
	* @apiDescription Delete one user
	*
	* @apiParam {String}	name screen name of the user
	*
	* @apiSuccess {}	
	* @apiExample Example usage:
	*		curl -X DELETE -H "Content-Type: application/json" http://localhost/users/test
	*
	* @apiSuccessExample Success-Response:
	*     HTTP/1.1 204 OK
	*
	* @apiError NoData The given ID is invalid
###
exports.delete = (request, response) ->
	request.models.users.find({screen_name: request.params.name}).remove (err) ->
		if err
			object = new ErrorObject('NoData')
			response.statusCode = 400
			return response.json object
		object = new ResponseObject('NoData')
		response.statusCode = 204
		response.json object


###*
	** @api {get} /users/:name/topics Get user
	* @apiVersion 0.0.1
	* @apiName get
	*
	* @apiDescription Get one user
	*
	* @apiParam {String} name Screen name of the user
	*
	* @apiSuccess {Array}	result	requested data
	*	@apiExample Example usage:
	*		curl -X GET -H Content-Type: application/json"  http://localhost/users/user
	*
	* @apiSuccessExample Success-Response:
	*     HTTP/1.1 200 OK
	*     {
	*       "result": [{"id" : 1, "name": "apple"}]
	*     }
	*
	* @apiError NoData The given ID is invalid
###
exports.getTopics = (request, response) ->
	request.models.users.find {screen_name: request.params.name}, (err, items) ->
		if err
			object = new ErrorObject('NoData')
			response.statusCode = 400
			return response.json object
		_(items).each (item) ->
			tweets.getTagsForUser item.screen_name, (err, results) ->
				if err
					object = new ErrorObject('NoData')
					response.statusCode = 400
					return response.json object
				object = new ResponseObject(results)
				response.json object