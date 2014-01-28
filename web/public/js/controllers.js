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
    $scope.params = {};

    $scope.page = 1;
    $scope.totalItems = 0;

    $scope.fetchResult = function() {
      $http({
        method: 'GET',
        url: '/api/users/influential',
        params: $scope.params
      }).
      success(function (data, status, headers, config) {
        $scope.influentialUsers = data.result.users;
        $scope.totalItems = data.result.totalItems;
      }).
      error(function (data, status, headers, config) {
        $scope.name = 'Error!'
      });
    };

    $scope.selectPage = function (page) {
      $scope.page = page;
      $scope.params.skip = 20 * ($scope.page - 1);
      $scope.fetchResult();
    };

    $scope.selectPage(1);
  }).
  controller('FocusedUsersCtrl', function ($scope, $http) {
    $http({
      method: 'GET',
      url: '/api/users/focused'
    }).
    success(function (data, status, headers, config) {
      $scope.focusedUsers = data.result;
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
