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
	WHERE left(t.text, 4)<>'RT @'
	WITH u, SUM(t.retweet_count)/COUNT(t) as tweets_retweet_count, SUM(t.favorite_count)/COUNT(t) as tweets_favorite_count
	WITH MAX(tweets_retweet_count) as tweets_retweet_count_max, MAX(tweets_favorite_count) as tweets_favorite_count_max, MAX(u.followers_count) as followers_count_max, MAX(u.listed_count) as listed_count_max
	MATCH (u:User)-[:tweets]->(t:Tweet)
	WHERE left(t.text, 4)<>'RT @'
	WITH u as user, SUM(t.retweet_count)/count(t) as tweets_retweet_count, SUM(t.favorite_count)/count(t) as tweets_favorite_count, tweets_retweet_count_max, tweets_favorite_count_max, followers_count_max, listed_count_max
	RETURN user, tweets_retweet_count, tweets_favorite_count,
	((0.4*tweets_retweet_count)/tweets_retweet_count_max + (0.3*tweets_favorite_count)/tweets_favorite_count_max + (0.2*user.followers_count)/followers_count_max + (0.1*user.listed_count)/listed_count_max) AS influence_factor
	ORDER BY influence_factor DESC SKIP {skip} LIMIT {limit}
	"""

	neodb.query(query, {skip: parseInt(skip) || 0, limit: parseInt(limit) || 20}, callback)