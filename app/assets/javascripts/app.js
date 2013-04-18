var app = angular.module("hairsprayTickets", ["ngResource"]);

app.config(["$routeProvider", function($routeProvider) {
  $routeProvider.
    when("/auftritte", {templateUrl: "templates/gigs.html", controller: "GigListCtrl"}).
    when("/auftritte/:gigId", {templateUrl: "templates/gig.html", controller: "GigCtrl"}).
    otherwise({redirectTo: "/auftritte"});
}]);
