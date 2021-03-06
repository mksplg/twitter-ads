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
    $scope.filter = {};

    $scope.page = 1;
    $scope.totalItems = 0;
    $scope.numPages = 0;

    $scope.fetchResults = function() {
      $scope.loading = true;
      var params = $scope.filter
      $http({
        method: 'GET',
        url: '/api/users',
        params: params
      }).
      success(function (data, status, headers, config) {
        $scope.users = data.result.users;
        $scope.totalItems = data.result.totalItems;
        $scope.loading = false;
      }).
      error(function (data, status, headers, config) {
        $scope.name = 'Error!'
        $scope.totalItems = 0;
        $scope.loading = false;
      });
    };

    $scope.find = function() {
      $scope.selectPage(1);
    };

    $scope.clear = function() {
      $scope.filter = {};
      $scope.selectPage(1);
    };

    $scope.selectPage = function (page) {
      $scope.page = page;
      $scope.filter.skip = 20 * ($scope.page - 1);
      $scope.fetchResults();
    };

    $scope.selectPage(1);


  }).
  controller('InfluentialCtrl', function ($scope, $http) {
    $scope.filter = {};
    $scope.filter.sortOrder = "DESC";

    $scope.page = 1;
    $scope.totalItems = 0;
    $scope.numPages = 0;

    $scope.fetchResults = function() {
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
        $scope.totalItems = 0;
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
      $scope.fetchResults();
    };

    $scope.setSortOrder = function (sortOrder) {
      $scope.filter.sortOrder = sortOrder;
      $scope.selectPage(1);
    };

    $scope.selectPage(1);
  }).
  controller('FocusedUsersCtrl', function ($scope, $http) {
    $scope.filter = {};
    $scope.filter.sortOrder = "DESC";

    $scope.page = 1;
    $scope.totalItems = 0;
    $scope.numPages = 0;

    $scope.fetchResults = function() {
      $scope.loading = true;
      var params = $scope.filter
      $http({
        method: 'GET',
        url: '/api/users/focused',
        params: params
      }).
      success(function (data, status, headers, config) {
        $scope.focusedUsers = data.result.users;
        $scope.totalItems = data.result.totalItems;
        $scope.loading = false;
      }).
      error(function (data, status, headers, config) {
        $scope.name = 'Error!'
        $scope.totalItems = 0;
        $scope.loading = false;
      });
    };

    $scope.selectPage = function (page) {
      $scope.page = page;
      $scope.filter.skip = 20 * ($scope.page - 1);
      $scope.fetchResults();
    };

    $scope.setSortOrder = function (sortOrder) {
      $scope.filter.sortOrder = sortOrder;
      $scope.selectPage(1);
    };

    $scope.selectPage(1);
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
  controller('TopicsCtrl', function ($scope, $http, $routeParams) {
    $scope.totalItems = 0;

    $scope.fetchResults = function() {
      $scope.loading = true;
      $http({
        method: 'GET',
        url: '/api/user/' + $routeParams.name + '/topics'
      }).
      success(function (data, status, headers, config) {
        $scope.totalItems = data.result.length;
        $scope.topics = data.result;
        $scope.loading = false;
      }).
      error(function (data, status, headers, config) {
        $scope.name = 'Error!'
        $scope.loading = false;
      });
    };

    $scope.fetchResults();
  }).
  controller('PotentialTopicsCtrl', function ($scope, $http, $routeParams) {
    $scope.totalItems = 0;

    $scope.fetchResults = function() {
      $scope.loading = true;
      $http({
        method: 'GET',
        url: '/api/user/' + $routeParams.name + '/potentialTopics'
      }).
      success(function (data, status, headers, config) {
        $scope.topics = data.result;
        $scope.totalItems = data.result.length;
        $scope.loading = false;
      }).
      error(function (data, status, headers, config) {
        $scope.name = 'Error!'
        $scope.totalItems = 0;
        $scope.loading = false;
      });
    };

    $scope.fetchResults();
  }).
  controller('TopicCtrl', function ($scope, $http, $routeParams) {
    $scope.fetchResults = function() {
      $scope.topicLoading = true;

      $http({
        method: 'GET',
        url: '/api/topic/' + $routeParams.topic
      }).
      success(function (data, status, headers, config) {
        $scope.topic = data.result;
        $scope.topicLoading = false;
      }).
      error(function (data, status, headers, config) {
        $scope.name = 'Error!'
        $scope.topicLoading = false;
      });

      $scope.adsLoading = true;
      $http({
        method: 'GET',
        url: '/api/topic/' + $routeParams.topic + '/ads'
      }).
      success(function (data, status, headers, config) {
        $scope.ads = data.result.ads;
        $scope.adsLoading = false;
      }).
      error(function (data, status, headers, config) {
        $scope.name = 'Error!';
        $scope.adsLoading = false;
      });
    };
    $scope.fetchResults();
  });
