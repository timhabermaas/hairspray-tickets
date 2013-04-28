app.controller "GigListCtrl", ["$scope", "Gigs", ($scope, Gigs) ->
  $scope.gigs = Gigs.query()
]

app.controller "OrderCtrl", ["$scope", "$routeParams", "$location", "Gig", "GigOrders", "GigOrder", "Seat", "$http", ($scope, $routeParams, $location, Gig, GigOrders, GigOrder, Seat, $http) ->
  $scope.gig = Gig.get({id: $routeParams.gigId})
  $scope.orders = GigOrders.query({gigId: $routeParams.gigId})
  #$scope.selectedOrder = {name: "", reduced_count: 0, seats: []}

  #if $location.search().order
    #$scope.$watch("orders", () ->
    #  selectedOrder = _.find $scope.orders, (o) -> o.id == $location.search().order
    #  console.log selectedOrder
    #  $scope.selectedOrder = selectedOrder if selectedOrder
    #, true)
  #else
  #  $scope.selectedOrder = {name: "muh"}

  $scope.seats = Seat.query()
  $scope.$watch("seats", ->
    $scope.rows = _.groupBy $scope.seats, (s) ->
      s.row.y
  , true)

  $scope.orderedSeats = []
  $scope.$watch("orders", ->
    orderedSeats = _.map $scope.orders, (o) -> o.seats
    $scope.orderedSeats = _.flatten orderedSeats
  , true)

  # hs-seatcolor="seat"
  $scope.fillColor = (order) ->
    if order.paid
      "rgba(51, 204, 100, 0.8)"
    else
      "rgba(243, 156, 18, 0.8)"

  $scope.strokeColor = (order) ->
    if $scope.selectedOrder == order
      "#c0392b"
    else
      "none"

  $scope.selectSeat = (seat) ->
    return if !seat.usable
    $scope.selectedOrder.seats.push(seat)

  $scope.deselectSeat = (seat) ->
    return unless seat in $scope.selectedOrder.seats
    $scope.selectedOrder.seats = (s for s in $scope.selectedOrder.seats when s != seat)

  $scope.selectOrder = (order) ->
    $scope.selectedOrder = order
    $location.search("order", order.id)

  $scope.newOrder = ->
    $scope.selectedOrder = {name: "Besucher ##{$scope.orders.length}", reduced_count: 0, seats: []}
    $scope.orders.push $scope.selectedOrder
    $location.search("order", "")

  $scope.pay = (order) ->
    $http.post("/api/gigs/#{$scope.gig.id}/orders/#{order.id}/pay.json").success (response) ->
      order.paid_at = response.paid_at
      order.paid = true

  $scope.unpay = (order) ->
    $http.post("/api/gigs/#{$scope.gig.id}/orders/#{order.id}/unpay.json").success (response) ->
      order.paid_at = response.paid_at
      order.paid = false

  $scope.save = (order) ->
    seatIds = _.map(order.seats, (s) -> s.id)
    params = {order: {name: order.name, seat_ids: seatIds, reduced_count: order.reduced_count, paid_at: order.paid_at}}
    if order.id
      $http.put("/api/gigs/#{$scope.gig.id}/orders/#{order.id}.json", params).success((response) ->
        order.error = false
      ).error (response) ->
        order.error = true
        order.errors = response
    else
      $http.post("/api/gigs/#{$scope.gig.id}/orders.json", params).success((response) ->
        order.id = response.id
        order.error = false
      ).error (response) ->
        order.error = true
]

app.controller "OrderListCtrl", ["$scope", ($scope) ->
  $scope.filters = [{name: "Alle", f: "{}"}, {name: "Nicht bezahlt", f: "notPaid"}]
  $scope.currentFilter = $scope.filters[0]
  $scope.selectFilter = (filter) ->
    $scope.currentFilter = filter
]
