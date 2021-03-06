var app = angular.module("hairsprayTickets", ["ngResource"]);

app.config(["$routeProvider", "$httpProvider", function($routeProvider, $httpProvider) {
  $routeProvider.
    when("/accounts", {templateUrl: "templates/accounts.html", controller: "AccountsController"}).
    when("/accounts/new", {templateUrl: "templates/new_account.html", controller: "NewAccountController"}).
    when("/auffuehrungen", {templateUrl: "templates/gigs.html", controller: "GigListController"}).
    when("/auffuehrungen/:gigId/orders", {templateUrl: "templates/order.html", controller: "OrderController", reloadOnSearch: false}).
    otherwise({redirectTo: "/auffuehrungen"});

  $httpProvider.defaults.headers.common["X-CSRF-Token"] = $("meta[name=csrf-token]").attr("content");
}]);
