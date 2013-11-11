
#require all testfiles
tests = []
for file of window.__karma__.files
	tests.push file  if /Spec\.js$/.test(file)  if window.__karma__.files.hasOwnProperty(file)
require.config
	baseUrl: "/base/public/js/"
	paths:
		jquery: "http://cdn.jsdelivr.net/jquery/2.0.3/jquery-2.0.3.min"
		bootstrap: "http://cdn.jsdelivr.net/bootstrap/3.0.0rc1/js/bootstrap.min"
		chai: "vendor/chai"

	shim:
		jquery: 
			exports: "$"

		bootstrap:
			deps: ["jquery"]
		chai: {}

	deps: tests
	callback: window.__karma__.start
