db = {}

exports.setup = (userdb) ->
	db = userdb
	db.serialize ->
		db.run("CREATE TABLE Users (username TEXT UNIQUE, name TEXT)")

exports.get = (usename, callback) ->
	db.get("SELECT * FROM Users WHERE username=?", username, callback)

exports.getAll = (callback) ->
	db.all("SELECT * FROM Users", callback)

exports.create = (data) ->
	stmt = db.prepare("INSERT INTO Users VALUES (:username, :name)")
	sqlData =
		':username': data['username']
		':name': data['name']
	stmt.run(sqlData)
	stmt.finalize()
	data

exports.update = (username, data) ->
	stmt = db.prepare("UPDATE Users SET name = :name WHERE username = :username")
	sqlData =
		':username': username
		':name': data['name']
	stmt.run(sqlData)
	stmt.finalize()

exports.delete = (usename) ->
	stmt = db.prepare("DELETE FROM Users WHERE username = :username")
	stmt.run(usename)
	stmt.finalize()
