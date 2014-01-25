neo4j = require('neo4j')
config = require('../../config/config')

neodb = new neo4j.GraphDatabase(config.neo4j_connection)

module.exports.getUsersForTopic = (topic, callback) ->
	query = """
	START u=node(*)
	MATCH (t)<-[:tweets]-(u)
	WHERE HAS (t.text) AND t.text =~ {topic}
	RETURN u.screen_name as screen_name, count(*) as count
	ORDER BY count DESCENDING;
	"""

	neodb.query(query, {topic: '.*' + topic + '.*'}, callback)

module.exports.getTagsForUser = (screen_name, limit, callback) ->
	query = """
	START u=node(*)
	MATCH (h)<-[:has_hashtag]-(t)<-[:tweets]-(u)
	WHERE HAS (u.name) AND u.screen_name = {screen_name}
	RETURN h.text as topic, count(*) as count
	ORDER BY count DESCENDING LIMIT {limit};
	"""

	neodb.query(query, {screen_name: screen_name, limit: parseInt(limit) || 5}, callback)

module.exports.getInfluential = (skip, limit, callback) ->
	query = """
	MATCH (u:User)-[:tweets]->(t:Tweet)
	WITH u as user, SUM(t.retweet_count) as tweets_retweet_count, SUM(t.favorite_count) as tweets_favorite_count
	RETURN user, tweets_retweet_count, tweets_favorite_count, 
		tweets_retweet_count*0.4+tweets_favorite_count*0.3+user.followers_count*0.2+user.listed_count*0.1 AS influence_factor
	ORDER BY influence_factor DESC SKIP {skip} LIMIT {limit}
	"""

	neodb.query(query, {skip: parseInt(skip) || 0, limit: parseInt(limit) || 20}, callback)