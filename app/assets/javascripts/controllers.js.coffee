app.controller "AccountsController", ["$scope", "Account", ($scope, Account) ->
  $scope.accounts = Account.query()
]

app.controller "SessionController", ["$scope", "$http", "$location", "Session", ($scope, $http, $location, Session) ->
  $scope.user = {name: "", password: ""}

  $scope.session = Session

  $scope.login = ->
    Session.logIn($scope.user.name, $scope.user.password).then ->
      $location.path("/")

  $scope.logout = ->
    Session.logOut()
    $location.path("/")

  Session.getCurrent()
]

app.controller "GigListController", ["$scope", "Gig", ($scope, Gig) ->
  $scope.gigs = Gig.query()
]

app.controller "OrderController", ["$scope", "$routeParams", "$location", "Gig", "GigOrder", "SeatRepository", "Session", ($scope, $routeParams, $location, Gig, GigOrder, SeatRepository, Session) ->
  $scope.session = Session

  $scope.gig = Gig.get({id: $routeParams.gigId})
  $scope.orders = GigOrder.query({gigId: $routeParams.gigId}, (orders) ->
    if $location.search().order
      $scope.selectedOrder = _.find orders, (o) -> o.id == parseInt($location.search().order)
  )

  $scope.seats = SeatRepository.query()
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
    $scope.selectedOrder.seats.remove(seat)

  $scope.selectOrder = (order) ->
    $scope.selectedOrder = order
    $location.search("order", order.id)

  $scope.newOrder = ->
    $scope.selectedOrder = new GigOrder({name: "Besucher ##{$scope.orders.length}", reduced_count: 0, seats: []})
    $scope.orders.push $scope.selectedOrder
    $location.search("order", "")

  $scope.pay = (order) ->
    order.$pay({gigId: $scope.gig.id})

  $scope.unpay = (order) ->
    order.$unpay({gigId: $scope.gig.id})

  $scope.save = (order) ->
    seatIds = _.map(order.seats, (s) -> s.id)
    order.seat_ids = seatIds;
    if order.id
      order.$update({gigId: $scope.gig.id}, (r) ->
        order.error = false
      , (r) ->
        order.error = true
        order.errors = r.data.error
      )
    else
      order.$save({gigId: $scope.gig.id}, (r) ->
        order.error = false
      , (r) ->
        order.error = true
        order.errors = r.data.error
      )

  $scope.remove = (order) ->
    $scope.orders.remove(order)
    $scope.selectedOrder = null
    if order.id and confirm("Wollen Sie die Bestellung von #{order.name} wirklich löschen?")
      GigOrder.delete({gigId: $scope.gig.id, id: order.id})
]

app.controller "OrderListController", ["$scope", ($scope) ->
  $scope.filters = [{name: "Alle", f: "{}"}, {name: "Nicht bezahlt", f: "notPaid"}]
  $scope.currentFilter = $scope.filters[0]
  $scope.selectFilter = (filter) ->
    $scope.currentFilter = filter
]
