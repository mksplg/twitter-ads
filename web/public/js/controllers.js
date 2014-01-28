'use strict';

/* Controllers */

angular.module('twitterAds.controllers', []).
  controller('AppCtrl', function ($scope, $http) {

    $http({
      method: 'GET',
      url: '/api/users'
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
      url: '/api/users'
    }).
    success(function (data, status, headers, config) {
      $scope.users = data.result;
    }).
    error(function (data, status, headers, config) {
      $scope.name = 'Error!'
    });
  }).
  controller('InfluentialCtrl', function ($scope, $http) {
    $http({
      method: 'GET',
      url: '/api/users/influential'
    }).
    success(function (data, status, headers, config) {
      $scope.influentials = data.result;
    }).
    error(function (data, status, headers, config) {
      $scope.name = 'Error!'
    });
  }).
  controller('UserCtrl', function ($scope, $http, $routeParams) {
    $http({
      method: 'GET',
      url: '/api/user/' + $routeParams.name
    }).
    success(function (data, status, headers, config) {
      $scope.user = data.result;
    }).
    error(function (data, status, headers, config) {
      $scope.name = 'Error!'
    });

    $http({
      method: 'GET',
      url: '/api/user/' + $routeParams.name + '/topics'
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
      url: '/api/topics/' + $routeParams.topic
    }).
    success(function (data, status, headers, config) {
      $scope.topic = data.result;
    }).
    error(function (data, status, headers, config) {
      $scope.name = 'Error!'
    });

    $http({
      method: 'GET',
      url: '/api/topics/' + $routeParams.topic + '/ads'
    }).
    success(function (data, status, headers, config) {
      $scope.ads = data.result.ads;
    }).
    error(function (data, status, headers, config) {
      $scope.name = 'Error!'
    });
  });
