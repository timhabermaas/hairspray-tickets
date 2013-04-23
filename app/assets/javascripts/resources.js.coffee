commonParameters = [{id: "@id"}, {update: {method: "PUT"}}]

app.factory "Gig", ["$resource", ($resource) ->
  $resource "api/gigs/:id", commonParameters...
]

app.factory "Order", ["$resource", ($resource) ->
  $resource "api/orders/:id", commonParameters...
]

app.factory "GigOrder", ["$resource", ($resource) ->
  $resource "api/gigs/:gigId/orders/:id", commonParameters...
]

app.factory "Seat", ["$resource", ($resource) ->
  $resource "api/seats.json"
]
