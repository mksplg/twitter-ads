routes = module.exports = (app, controllers, middleware) ->
	app.get '/rest/users', controllers.users.getAll
	app.get '/rest/users/:name', controllers.users.get
	app.post '/rest/users', controllers.users.post
	app.delete '/rest/users/:name', controllers.users.delete

	app.get '/', (request, response) -> 
		response.render 'index', {title: "Home", id: "home"}
	app.get '/partials/:name', (request, response) -> 
		name = request.params.name
		response.render 'partials/' + name, {title: name, id: name}
	app.get '*', (request, response) -> 
		response.render 'index', {title: "Home", id: "home"}
