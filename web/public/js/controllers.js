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
    $scope.filter = {};

    $scope.page = 1;
    $scope.totalItems = 0;
    $scope.numPages = 0;

    $scope.fetchResult = function() {
      $scope.loading = true;
      var params = $scope.filter
      $http({
        method: 'GET',
        url: '/api/users/influential',
        params: params
      }).
      success(function (data, status, headers, config) {
        $scope.influentialUsers = data.result.users;
        $scope.totalItems = data.result.totalItems;
        $scope.loading = false;
      }).
      error(function (data, status, headers, config) {
        $scope.name = 'Error!'
        $scope.loading = false;
      });
    };

    $scope.calculate = function() {
      $scope.selectPage(1);
    };

    $scope.clear = function() {
      $scope.filter = {};
      $scope.selectPage(1);
    };

    $scope.selectPage = function (page) {
      $scope.page = page;
      $scope.filter.skip = 20 * ($scope.page - 1);
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
