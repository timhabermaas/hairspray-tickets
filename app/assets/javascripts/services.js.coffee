app.factory "Session", ["SessionResource", "$http", (SessionResource, $http) ->
  session = {loggedIn: false, name: ""}

  session.logIn = (user, password) ->
    SessionResource.save({login: user, password: password}, (response) ->
      session.name = response.login
      session.role = response.role
      session.loggedIn = true
    , (response) ->
      session.logOut()
    )

  session.logOut = ->
    $http({method: "DELETE", url: "/api/v1/sessions/current"}).success (data, status, headers, config) ->
      session.loggedIn = false
      session.name = null
      session.apiKey = null

  session
]
