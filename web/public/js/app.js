'use strict';

// Declare app level module which depends on filters, and services

angular.module('twitterAds', [
  'twitterAds.controllers',
  'twitterAds.filters',
  'twitterAds.services',
  'twitterAds.directives',
  'ngRoute'
]).
config(function ($routeProvider, $locationProvider) {
  $routeProvider.
    when('/users', {
      templateUrl: 'partials/users',
      controller: 'UsersCtrl'
    }).
    when('/users/:name', {
      templateUrl: 'partials/user',
      controller: 'UserCtrl'
    }).
    otherwise({
      redirectTo: '/users'
    });

  $locationProvider.html5Mode(true);
});
