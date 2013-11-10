items = ['User1', 'User2']

exports.get = (id) ->
	items[id]

exports.getAll = () ->
	items

exports.create = (data) ->
	items.push data
	data


exports.update = (id, data) ->
	items[id] = data

exports.delete = (id) ->
	items.splice id, 1
	id

