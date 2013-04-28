commonParameters = [{id: "@id"}, {update: {method: "PUT"}}]

app.factory "Gig", ["$resource", ($resource) ->
  $resource "api/gigs/:id", commonParameters...
]

app.factory "Gigs", ["$resource", ($resource) ->
  $resource "api/gigs.json", {}, {query: {method: "GET", isArray: true}}
]

app.factory "Order", ["$resource", ($resource) ->
  $resource "api/orders/:id.json", {id: "@id"}, {get: {method: "GET"}, remove: {method: "DELETE"}, "delete": {method: "DELETE"}, update: {method: "PUT"}}
]

app.factory "GigOrder", ["$resource", ($resource) ->
  $resource "api/gigs/:gigId/orders/:id.json", {id: "@id"}, {get: {method: "GET"}, remove: {method: "DELETE"}, "delete": {method: "DELETE"}, update: {method: "PUT"}}
]

app.factory "GigOrders", ["$resource", ($resource) ->
  $resource "api/gigs/:gigId/orders.json", {}, {query: {method: "GET", isArray: true}, save: {method: "POST", isArray: false}}
]

app.factory "Seat", ["$resource", ($resource) ->
  $resource "api/seats.json"
]
