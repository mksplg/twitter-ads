###
Module dependencies.
###
express = require("express")
http = require("http")
path = require("path")
orm = require('orm')
config = require('../config/config')

sqlModels = require('./models/sqlmodels')

fileloader = require("loadfiles")
loadFilesFor = fileloader __dirname, 'js'
routes = require("./routes")
app = module.exports = express()

# all environments
app.set "views", __dirname + "/views"
app.set "view engine", "jade"
app.use express.favicon()

app.use(express.logger('dev'))
app.use express.bodyParser()
app.use express.methodOverride()
app.use express.static(path.join(__dirname, "../public"))

app.use(orm.express(config.sql_opts, {
	define: sqlModels
}));

app.use app.router

# development only
app.use express.errorHandler() if "development" is app.get("env")

# Models
#models = loadFilesFor('models')
#userdb = new sqlite3.Database(process.env.USERDB or ':memory:')

# for modelName of models
# 	if models[modelName].setup
# 		models[modelName].setup(userdb)

# Require all available controllers
controllers = loadFilesFor('controllers')

# Require all available middlewares
middlewares = loadFilesFor('middlewares')

routes(app, controllers, middlewares)