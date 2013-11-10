'use strict';

/* Directives */

angular.module('twitterAds.directives', []).
  directive('appVersion', function (version) {
    return function(scope, elm, attrs) {
      elm.text(version);
    };
  });
