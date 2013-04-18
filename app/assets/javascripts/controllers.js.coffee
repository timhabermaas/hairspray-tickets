Array::unique = ->
  output = {}
  output[@[key]] = @[key] for key in [0...@length]
  value for key, value of output

app.controller "GigListCtrl", ["$scope", ($scope) ->
  $scope.gigs = [{title: "muh", id: 2}]
]

app.controller "GigCtrl", ["$scope", "Order", ($scope, Order) -> # TODO add selectedOrder as a service (selectedItem)?
  $scope.selectOrder = (order) ->
    $scope.selectedOrder = order

  $scope.seatSelected = (seat) ->
    seat.id in $scope.selectedOrder.seats

  $scope.newOrder = ->
    $scope.selectedOrder = { seats: [], reduced: 0 }

  $scope.reservedSeats = ->
    result = (order.seats for order in $scope.orders)
    [].concat result...

  $scope.seatReserved = (seat) ->
    seat.id in $scope.reservedSeats()

  $scope.seatPaid = (seat) ->
    potentialOrders = (order for order in $scope.orders when seat.id in order.seats)
    if potentialOrders.length > 0
      potentialOrders[0].paid
    else
      false

  $scope.chooseSeat = (seat) ->
    if $scope.seatSelected(seat)
      i = $scope.selectedOrder.seats.indexOf(seat.id)
      $scope.selectedOrder.seats.splice(i, 1)
    else
      $scope.selectedOrder.seats.push(seat.id) unless seat.reserved

  $scope.save = ->
    if $scope.selectedOrder.id == undefined
      # add to server
      Order.add($scope.selectedOrder)
      $scope.newOrder()
    else
      # add to list
      #save to service

  $scope.orders = Order.query()

  $scope.seats = [
                  {id: 1, row: 1, seat: 1}
                  {id: 2, row: 1, seat: 2}
                  {id: 3, row: 1, seat: 3}
                  {id: 4, row: 2, seat: 1}
                  {id: 5, row: 2, seat: 2}
                ]

  $scope.$watch("orders", (newValue, oldValue) ->
    $scope.seats = ({id: seat.id, row: seat.row, seat: seat.seat, reserved: $scope.seatReserved(seat), paid: $scope.seatPaid(seat)} for seat in $scope.seats)
  , true)

  $scope.rows = ->
    (seat.row for seat in $scope.seats).unique().reverse()

  $scope.filters = ["Alle", "Nicht bezahlt für > 1 Woche "]
  $scope.currentFilter = "Alle"
  $scope.selectFilter = (filter) ->
    $scope.currentFilter = filter

  $scope.newOrder()
]
