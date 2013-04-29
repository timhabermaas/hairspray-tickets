describe "Filters", ->
  describe "seatDescriptionsFilter", ->
    seatDescriptions = angular.injector(["hairsprayTickets"]).get("seatDescriptionsFilter")

    it "groups consecutive seats in one row", ->
      seats = [
        { number: 1, row: {number: 1} },
        { number: 2, row: {number: 1} },
        { number: 3, row: {number: 1} },
        { number: 5, row: {number: 1} },
        { number: 10, row: {number: 1} },
        { number: 1, row: {number: 2} },
      ]
      expect(seatDescriptions(seats)).toEqual ["Reihe 1, Platz 1-3, 5, 10", "Reihe 2, Platz 1"]

    it "can handle an empty array/null gracefully", ->
      expect(seatDescriptions([])).toEqual []
      expect(seatDescriptions(null)).toEqual []
