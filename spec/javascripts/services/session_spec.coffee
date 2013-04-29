describe "Services", ->
  describe "Session", ->
    Session = angular.injector(["hairsprayTickets"]).get("Session")

    it "is logged out by default", ->
      expect(Session.loggedIn).toEqual(false)

    it "sets loggedIn to true after logging in", ->
      Session.logIn()
      expect(Session.loggedIn).toEqual(true)

    it "sets loggedIn to false after logging out", ->
      Session.logOut()
      expect(Session.loggedIn).toEqual(false)
