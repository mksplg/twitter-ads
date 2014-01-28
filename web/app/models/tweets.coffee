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
	WITH u, SUM(t.retweet_count)/COUNT(t) as tweets_retweet_mean, SUM(t.favorite_count)/COUNT(t) as tweets_favorite_mean
	WITH MAX(tweets_retweet_mean) as tweets_retweet_mean_max, MAX(tweets_favorite_mean) as tweets_favorite_mean_max, MAX(u.followers_count) as followers_count_max, MAX(u.listed_count) as listed_count_max
	MATCH (u:User)-[:tweets]->(t:Tweet)
	WHERE left(t.text, 4)<>'RT @'
	WITH u as user, SUM(t.retweet_count)/count(t) as tweets_retweet_mean, SUM(t.favorite_count)/count(t) as tweets_favorite_mean, tweets_retweet_mean_max, tweets_favorite_mean_max, followers_count_max, listed_count_max
	RETURN user, tweets_retweet_mean, tweets_favorite_mean,
	((0.3*tweets_retweet_mean)/tweets_retweet_mean_max + (0.3*tweets_favorite_mean)/tweets_favorite_mean_max + (0.3*user.followers_count)/followers_count_max + (0.1*user.listed_count)/listed_count_max) AS influence_factor
	ORDER BY influence_factor DESC SKIP {skip} LIMIT {limit}
	"""

	neodb.query(query, {skip: parseInt(skip) || 0, limit: parseInt(limit) || 20}, callback)

module.exports.getFocused = (skip, limit, callback) ->
	query = """
	MATCH (h:Hashtag)<-[:has_hashtag]-(t:Tweet)<-[:tweets]-(u:User)
	WITH u AS user, COUNT(DISTINCT h) AS num_topics, COUNT(h) AS num_per_topic
	RETURN user, num_topics, SUM(num_per_topic) AS sum_topic_usage, 1.0-num_topics*1.0/SUM(num_per_topic) AS focus_factor
	ORDER BY focus_factor DESC SKIP {skip} LIMIT {limit}
	"""

	neodb.query(query, {skip: parseInt(skip) || 0, limit: parseInt(limit) || 20}, callback)