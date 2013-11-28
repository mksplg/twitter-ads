'use strict';

/* Filters */

angular.module('twitterAds.filters', []).
  filter('interpolate', function (version) {
    return function (text) {
      return String(text).replace(/\%VERSION\%/mg, version);
    }
  }).
  filter('profile_image_bigger', function() {
    return function(text) {
		return String(text).replace(/_normal\./, '_bigger.');
    }
  });
