'use strict';

/* Controllers */

angular.module('twitterAds.controllers', []).
  controller('AppCtrl', function ($scope, $http) {

    $http({
      method: 'GET',
      url: '/rest/users'
    }).
    success(function (data, status, headers, config) {
      $scope.users = data.result;
    }).
    error(function (data, status, headers, config) {
      $scope.name = 'Error!'
    });

  }).
  controller('UsersCtrl', function ($scope, $http) {
    $http({
      method: 'GET',
      url: '/rest/users'
    }).
    success(function (data, status, headers, config) {
      $scope.users = data.result;
    }).
    error(function (data, status, headers, config) {
      $scope.name = 'Error!'
    });
  }).
  controller('UserCtrl', function ($scope, $http, $routeParams) {
    $http({
      method: 'GET',
      url: '/rest/users/' + $routeParams.name
    }).
    success(function (data, status, headers, config) {
      $scope.user = data.result;
    }).
    error(function (data, status, headers, config) {
      $scope.name = 'Error!'
    });

    $http({
      method: 'GET',
      url: '/rest/users/' + $routeParams.name + '/topics'
    }).
    success(function (data, status, headers, config) {
      $scope.topics = data.result;
    }).
    error(function (data, status, headers, config) {
      $scope.name = 'Error!'
    });
  }).
  controller('TopicCtrl', function ($scope, $http, $routeParams) {
    $http({
      method: 'GET',
      url: '/rest/topics/' + $routeParams.topic
    }).
    success(function (data, status, headers, config) {
      $scope.topic = data.result;
    }).
    error(function (data, status, headers, config) {
      $scope.name = 'Error!'
    });
  });
