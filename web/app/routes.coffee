routes = module.exports = (app, controllers, middleware) ->
	app.get '/rest/users', controllers.users.getAll

