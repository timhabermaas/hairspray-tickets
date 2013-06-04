app.controller "PageController", ["$scope", "$location", "Session", ($scope, $location, Session) ->
  $scope.session = Session
  $scope.location = $location

  setNavigationVisibility = ->
    isOnOrdersPage = $scope.location.path().match(/\/auffuehrungen\/[0-9]+\/orders/)
    isLoggedIn = $scope.session.loggedIn

    $scope.showNavigation = isLoggedIn || !isOnOrdersPage

  $scope.$watch("session", ->
    setNavigationVisibility()
  , true)

  $scope.$watch("location.path()", ->
    setNavigationVisibility()
  , true)
]

app.controller "AccountsController", ["$scope", "Account", ($scope, Account) ->
  $scope.accounts = Account.query()

  $scope.remove = (account) ->
    if confirm("User #{account.login} wirklich löschen?")
      account.$remove (response) ->
        $scope.accounts = _.reject($scope.accounts, (a) -> a.id == account.id)
]

app.controller "SessionController", ["$scope", "$http", "$location", "Session", ($scope, $http, $location, Session) ->
  $scope.user = {name: "", password: ""}

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

app.controller "OrderController", ["$scope", "$routeParams", "$location", "Gig", "GigOrder", "SeatRepository", ($scope, $routeParams, $location, Gig, GigOrder, SeatRepository) ->
  $scope.gig = Gig.get({id: $routeParams.gigId})
  $scope.gigs = Gig.query()
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
      "rgba(200, 0, 0, 0.7)"
    else
      "rgba(243, 156, 18, 0.8)"

  $scope.strokeColor = (order) ->
    if $scope.selectedOrder == order
      "#0000c8"
    else
      "none"

  $scope.selectSeat = (seat) ->
    return unless $scope.selectedOrder
    return if !seat.usable || $scope.selectedOrder.paid
    $scope.selectedOrder.seats.push(seat)

  $scope.clickReservedSeat = (seat, order) ->
    if order == $scope.selectedOrder
      $scope.selectedOrder.seats.remove(seat) unless $scope.selectedOrder.paid
    else
      $scope.selectedOrder = order

  $scope.selectOrder = (order) ->
    $scope.selectedOrder = order
    $location.search("order", order.id)

  deselectOrder = () ->
    $scope.selectedOrder = null
    $location.search("order", null)

  $scope.newOrder = ->
    $scope.selectedOrder = new GigOrder({reduced_count: 0, seats: []})
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
        deselectOrder()
      , (r) ->
        order.error = true
        order.errors = r.data.error
      )
    else
      order.$save({gigId: $scope.gig.id}, (r) ->
        order.error = false
        deselectOrder()
      , (r) ->
        order.error = true
        order.errors = r.data.error
      )

  $scope.remove = (order) ->
    if order.id and confirm("Wollen Sie die Bestellung von #{order.name} wirklich löschen?")
      GigOrder.delete({gigId: $scope.gig.id, id: order.id}, (response) ->
        $scope.orders.remove(order)
        deselectOrder()
      )
]

app.controller "OrderListController", ["$scope", ($scope) ->
  all = (order) ->
    true

  notPaid = (order) ->
    !order.paid

  # TODO angular doesn't seem to filter at all when using "orders | {paid: false}"
  #      therefore: workaround using functions
  $scope.filters = [{name: "Alle", f: all}, {name: "Nicht bezahlt", f: notPaid}]
  $scope.currentFilter = $scope.filters[0]
  $scope.selectFilter = (filter) ->
    $scope.currentFilter = filter
]

app.controller "NewAccountController", ["$scope", "$location", "Account", ($scope, $location, Account) ->
  $scope.save = (account) ->
    Account.save(account, (response) ->
      $location.path("/accounts")
    , (response) ->
      account.error = true
      account.errors = response.data.error
    )
]
