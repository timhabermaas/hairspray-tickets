app.controller "GigListCtrl", ["$scope", "Gig", ($scope, Gig) ->
  $scope.gigs = Gig.query()
]

app.controller "SeatsCtrl", ["$scope", "Seat", ($scope, Seat) ->
  $scope.seats = Seat.query()

  $scope.$watch("seats", ->
    $scope.rows = _.groupBy $scope.seats, (s) ->
      s.row.y
  , true)
]

app.controller "GigCtrl", ["$scope", "$routeParams", "GigOrder", "Gig", ($scope, $routeParams, GigOrder, Gig) -> # TODO add selectedOrder as a service (selectedItem)?
  $scope.gig = Gig.get({id: $routeParams.gigId})
  $scope.orders = GigOrder.query({gigId: $routeParams.gigId})

#  if $routeParams.orderId
#    $scope.currentOrder = Order.get({orderId: $routeParams.orderId}) # TODO remove dependency by looking through orders array

  $scope.selectOrder = (order) ->
    $scope.currentOrder = order
  $scope.orderSelected = (order) ->
    $scope.currentOrder == order
]

app.controller "OrderListCtrl", ["$scope", "$routeParams", "GigOrder", ($scope, $routeParams, GigOrder) ->
  $scope.orders = GigOrder.query({gigId: $routeParams.gigId})

  $scope.orderUrl = (order) ->
    "#/auftritte/#{$routeParams.gigId}/orders/#{order.id}"

  $scope.filters = [{name: "Alle", f: "{}"}, {name: "Nicht bezahlt", f: "notPaid"}]
  $scope.currentFilter = $scope.filters[0]
  $scope.selectFilter = (filter) ->
    $scope.currentFilter = filter
]

app.controller "OrderDetailsCtrl", ["$scope", "Order", ($scope, Order) ->
  $scope.$watch "currentOrder", () ->
    $scope.order = $scope.currentOrder

  $scope.save = () ->
    Order.update $scope.order
]

app.controller "OrderBillCtrl", ["$scope", "Order", "Gig",  ($scope, Order, Gig) ->
  $scope.normalPrice = () ->
    if $scope.order
      ($scope.order.seats.length - $scope.order.reduced) * 15
  $scope.reducedPrice = () ->
    if $scope.order
      $scope.order.reduced * 12
  $scope.sum = () ->
    if $scope.order # TODO duplication/ugliness
      $scope.normalPrice() + $scope.reducedPrice()
]
