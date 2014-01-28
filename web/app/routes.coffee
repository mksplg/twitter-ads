routes = module.exports = (app, controllers, middleware) ->
	app.get '/api/users', controllers.users.getAll
	app.get '/api/users/influential', controllers.users.getInfluential
	app.get '/api/users/focused', controllers.users.getFocused
	app.get '/api/user/:name', controllers.users.get
	app.post '/api/users', controllers.users.post
	app.delete '/api/user/:name', controllers.users.delete

	app.get '/api/user/:name/topics', controllers.users.getTopics
	app.get '/api/user/:name/potentialtopics', controllers.users.getPotentialTopics

	app.get '/api/topic/:topic', controllers.topics.get
	app.get '/api/topic/:topic/ads', controllers.topics.getAds

	app.get '/', (request, response) -> 
		response.render 'index', {title: "Home", id: "home"}
	app.get '/partials/:name', (request, response) -> 
		name = request.params.name
		response.render 'partials/' + name, {title: name, id: name}
	app.get '*', (request, response) -> 
		response.render 'index', {title: "Home", id: "home"}
