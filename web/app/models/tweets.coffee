neo4j = require('neo4j')
config = require('../../config/config')

neodb = new neo4j.GraphDatabase(config.neo4j_connection)

module.exports.getUsersForTopic = (topic, callback) ->
	query = """
	MATCH (h:Hashtag)<-[:has_hashtag]-(t:Tweet)<-[:tweets]-(u:User)
	WHERE HAS (h.text) AND h.text = {topic}
	RETURN u.screen_name as screen_name, count(*) as count
	ORDER BY count DESCENDING;
	"""

	neodb.query(query, {topic: topic}, callback)

module.exports.getTopics = (screen_name, skip, limit, callback) ->
	query = """
	START u=node(*)
	MATCH (h)<-[:has_hashtag]-(t)<-[:tweets]-(u)
	WHERE HAS (u.name) AND u.screen_name = {screen_name}
	RETURN h.text as topic, count(*) as count
	ORDER BY count DESCENDING SKIP {skip} LIMIT {limit};
	"""

	neodb.query(query, {screen_name: screen_name, skip: parseInt(skip) || 0, limit: parseInt(limit) || 5}, callback)

module.exports.getUserCount = (callback) ->
	query = """
	MATCH (u:User)
	RETURN COUNT(*) as user_count
	"""

	neodb.query(query, callback)

module.exports.getInfluential = (sortOrder, skip, limit, retweetWeight, favoritesWeight, followersWeight, listedWeight, callback) ->
	query = """
	MATCH (u:User)-[:tweets]->(t:Tweet)
	WHERE left(t.text, 4)<>'RT @'
	WITH u, SUM(t.retweet_count)/COUNT(t) as tweets_retweet_mean, SUM(t.favorite_count)/COUNT(t) as tweets_favorite_mean
	WITH MAX(tweets_retweet_mean) as tweets_retweet_mean_max, MAX(tweets_favorite_mean) as tweets_favorite_mean_max, MAX(u.followers_count) as followers_count_max, MAX(u.listed_count) as listed_count_max
	MATCH (u:User)-[:tweets]->(t:Tweet)
	WHERE left(t.text, 4)<>'RT @'
	WITH u as user, SUM(t.retweet_count)/count(t) as tweets_retweet_mean, SUM(t.favorite_count)/count(t) as tweets_favorite_mean, tweets_retweet_mean_max, tweets_favorite_mean_max, followers_count_max, listed_count_max
	RETURN user, tweets_retweet_mean, tweets_favorite_mean,
	((1.0*{retweet_weight}*tweets_retweet_mean)/tweets_retweet_mean_max + (1.0*{favorites_weight}*tweets_favorite_mean)/tweets_favorite_mean_max + (1.0*{followers_weight}*user.followers_count)/followers_count_max + (1.0*{listed_weight}*user.listed_count)/listed_count_max) AS influence_factor
	ORDER BY influence_factor
	"""

	query += ' DESC' unless sortOrder == 'ASC' 
	query += ' SKIP {skip} LIMIT {limit}'

	params = {
		skip: parseInt(skip) || 0,
		limit: parseInt(limit) || 20,
		retweet_weight: parseFloat(retweetWeight),
		favorites_weight: parseFloat(favoritesWeight),
		followers_weight: parseFloat(followersWeight),
		listed_weight: parseFloat(listedWeight)
	}

	console.log(params)

	params.retweet_weight = 0.3 if not params.retweet_weight? || isNaN(params.retweet_weight)
	params.favorites_weight = 0.3 if not params.favorites_weight? || isNaN(params.favorites_weight)
	params.followers_weight = 0.3 if not params.followers_weight? || isNaN(params.followers_weight)
	params.listed_weight = 0.1 if not params.listed_weight? || isNaN(params.listed_weight)

	console.log(params)

	neodb.query(query, params, callback)

module.exports.getFocused = (sortOrder, skip, limit, callback) ->
	query = """
	MATCH (h:Hashtag)<-[:has_hashtag]-(t:Tweet)<-[:tweets]-(u:User)
	WITH u AS user, COUNT(DISTINCT h) AS num_topics, COUNT(h) AS num_per_topic
	RETURN user, num_topics, SUM(num_per_topic) AS sum_topic_usage, 1.0-num_topics*1.0/SUM(num_per_topic) AS focus_factor
	ORDER BY focus_factor
	"""

	query += ' DESC' unless sortOrder == 'ASC' 
	query += ' SKIP {skip} LIMIT {limit}'

	neodb.query(query, {skip: parseInt(skip) || 0, limit: parseInt(limit) || 20}, callback)

module.exports.getPotentialTopics = (screen_name, depth, skip, limit, callback) ->
	query = """
	MATCH (o:User)-[:follows*1..3]->(f:User)-[:tweets]->(t:Tweet)-[:has_hashtag]->(h:Hashtag) 
	WHERE o.screen_name={screen_name} AND NOT f.screen_name={screen_name} 
	WITH f, COUNT(DISTINCT h) AS num_topics 
	MATCH (o:User)-[:follows*1..3]->(f:User)-[:tweets]->(t:Tweet)-[:has_hashtag]->(h:Hashtag) 
	WHERE o.screen_name={screen_name} AND NOT f.screen_name={screen_name} 
	WITH f AS friend, num_topics, h AS topic, COUNT(h) AS num_per_topic 
	RETURN friend.screen_name as friend_screen_name, topic.text as topic, num_per_topic/1.0/num_topics AS num_per_topic_normalised 
	ORDER BY num_per_topic_normalised DESC SKIP {skip} LIMIT {limit}
	"""

	neodb.query(query, {screen_name: screen_name, depth: parseInt(depth) || 3, skip: parseInt(skip) || 0, limit: parseInt(limit) || 5}, callback)