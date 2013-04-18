var app = angular.module("hairsprayTickets", []);

app.config(["$routeProvider", function($routeProvider) {
  $routeProvider.
    when("/auftritte", {templateUrl: "templates/gigs.html", controller: "GigListCtrl"}).
    when("/auftritte/:concertId", {templateUrl: "templates/gig.html", controller: "GigCtrl"}).
    otherwise({redirectTo: "/auftritte"});
}]);
