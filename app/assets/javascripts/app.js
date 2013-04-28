var app = angular.module("hairsprayTickets", ["ngResource"]);

app.config(["$routeProvider", "$httpProvider", function($routeProvider, $httpProvider) {
  $routeProvider.
    when("/auftritte", {templateUrl: "templates/gigs.html", controller: "GigListCtrl"}).
    when("/auftritte/:gigId", {templateUrl: "templates/gig.html", controller: "GigCtrl"}).
    when("/auftritte/:gigId/orders", {templateUrl: "templates/order.html", controller: "OrderCtrl", reloadOnSearch: false}).
    otherwise({redirectTo: "/auftritte"});

  $httpProvider.defaults.headers.common["X-CSRF-Token"] = $("meta[name=csrf-token]").attr("content");
}]);
