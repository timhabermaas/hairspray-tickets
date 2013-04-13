Array::unique = ->
  output = {}
  output[@[key]] = @[key] for key in [0...@length]
  value for key, value of output

app.controller "OrderListCtrl", ($scope) ->
  $scope.orders = [
      { name: "Peter Mustermann", seats: [{row: 2, seat: 1}], reduced: 2, full: 4 }
      { name: "Dieter Heinzelmann", seats: [], reduced: 2, full: 4 }
    ]

  $scope.selectedOrder = null
  $scope.filters = ["Alle", "Reserviert", "Bezahlt"]
  $scope.currentFilter = "Alle"
  $scope.selectFilter = (filter) ->
    $scope.currentFilter = filter

  $scope.select = (order) ->
    $scope.selectedOrder = order

app.controller "SeatingCtrl", ($scope) ->
  $scope.seats = [
                  {row: 1, seat: 1}
                  {row: 1, seat: 2}
                  {row: 1, seat: 3}
                  {row: 2, seat: 1}
                ]

  $scope.rows = () ->
    (seat.row for seat in $scope.seats).unique().reverse()
