app.factory "Session", ["SessionResource", "$http", "$q", (SessionResource, $http, $q) ->
  session = {loggedIn: false, name: ""}

  session.logIn = (user, password) ->
    deferred = $q.defer()

    SessionResource.save({login: user, password: password}, (response) ->
      session.name = response.login
      session.role = response.role
      session.loggedIn = true
      deferred.resolve()
    , (response) ->
      session.logOut()
      deferred.reject()
    )

    deferred.promise

  session.logOut = ->
    $http({method: "DELETE", url: "/api/v1/sessions/current"}).success ->
      session.loggedIn = false
      session.name = null
      session.apiKey = null

  session.getCurrent = ->
    $http({method: "GET", url: "/api/v1/sessions/current"}).success (data) ->
      session.loggedIn = true
      session.name = data.login
      session.role = data.role

  session
]
