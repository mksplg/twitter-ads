'use strict';

// Declare app level module which depends on filters, and services

angular.module('twitterAds', [
  'ui.bootstrap',
  'ngSanitize',
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
    when('/users/influential', {
      templateUrl: 'partials/influential',
      controller: 'InfluentialCtrl'
    }).
    when('/users/focused', {
      templateUrl: 'partials/focused',
      controller: 'FocusedUsersCtrl'
    }).
    when('/user/:name', {
      templateUrl: 'partials/user',
      controller: 'UserCtrl'
    }).
    when('/topics/:topic', {
      templateUrl: 'partials/topic',
      controller: 'TopicCtrl'
    }).
    otherwise({
      redirectTo: '/users'
    });

  $locationProvider.html5Mode(true);
});
