app.factory "Session", () ->
  {
    loggedIn: false

    logIn: ->
      this.loggedIn = true

    logOut: ->
      this.loggedIn = false
  }
