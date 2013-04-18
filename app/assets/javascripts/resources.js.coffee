app.factory "Gig", ["$resource", ($resource) ->
  $resource("api/gigs/:gigId", {id: "@id"}, {update: {method: "PUT"}})
]
