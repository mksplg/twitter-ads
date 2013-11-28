neo4j = require('neo4j')
keys = require('../../config')

neodb = new neo4j.GraphDatabase(keys.neo4j_connection)

module.exports.getUsersForTopic = (topic, callback) ->
	query = """
	START u=node(*)
	MATCH (t)<-[:tweets]-(u)
	WHERE HAS (t.text) AND t.text =~ {topic}
	RETURN u.screen_name as screen_name, count(*) as count
	ORDER BY count DESCENDING;
	"""

	neodb.query(query, {topic: '.*' + topic + '.*'}, callback)

module.exports.getTagsForUser = (screen_name, callback) ->
	query = """
	START u=node(*)
	MATCH (h)<-[:has_hashtag]-(t)<-[:tweets]-(u)
	WHERE HAS (u.name) AND u.screen_name = {screen_name}
	RETURN h.text as topic, count(*) as count
	ORDER BY count DESCENDING;
	"""

	neodb.query(query, {screen_name: screen_name}, callback)