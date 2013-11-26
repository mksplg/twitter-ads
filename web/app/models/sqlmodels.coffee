module.exports = (db, models) ->
	db.load('./users', (err) ->
		if err
			console.log(err)
	)

	models.user = db.models.user

	db.sync((err) ->
		if err
			console.log(err)
	)
