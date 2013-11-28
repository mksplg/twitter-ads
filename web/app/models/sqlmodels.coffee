module.exports = (db, models) ->
	db.load('./users', (err) ->
		if err
			console.log(err)
	)

	models.users = db.models.users

	db.sync((err) ->
		if err
			console.log(err)
	)
