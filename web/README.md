# Twitter Ads

## Required software
* Node.js 0.10.25

	http://nodejs.org/
	
* NPM 1.3.x

	https://npmjs.org/
* Grunt-cli 0.1.11

	`npm install -g grunt-cli`

* MySQL

	`apt-get install mysql-server`
	
* Neo4j 2.0.0

	http://www.neo4j.org/
	
* MongoDB 2.4.8

	http://www.mongodb.org/


## Installation
1. Install local grunt

    `npm install grunt`
2. Install dependencies

    `npm install`
3. Configure installation

	Copy the configuration example using
	`cp config/config.coffee.example config/config.coffee` and update the settings with your database credentials

### Running
`npm start` executes grunt production and then starts twitter-ads

### Developing
`grunt` runs grunt test, grunt development and grunt watch

`node index.js` starts twitter-ads
