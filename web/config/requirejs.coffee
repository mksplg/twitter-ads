require.config
	baseUrl: "/js/"
	waitSeconds: 15
	paths:
		jquery: "http://cdn.jsdelivr.net/jquery/2.0.3/jquery-2.0.3.min"
		bootstrap: "http://cdn.jsdelivr.net/bootstrap/3.0.0rc1/js/bootstrap.min"

	shim:
		jQuery:
			exports: "$"

		bootstrap:
			deps: ["jquery"]


require ["jquery"], ($) ->
