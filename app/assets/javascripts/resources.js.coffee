commonParameters = [{id: "@id"}, {update: {method: "PUT"}}]

app.factory "Gig", ["$resource", ($resource) ->
  $resource "api/v1/gigs/:id", commonParameters...
]

app.factory "Gigs", ["$resource", ($resource) ->
  $resource "api/v1/gigs", {}, {query: {method: "GET", isArray: true}}
]

app.factory "Order", ["$resource", ($resource) ->
  $resource "api/orders/:id.json", {id: "@id"}, {get: {method: "GET"}, remove: {method: "DELETE"}, "delete": {method: "DELETE"}, update: {method: "PUT"}}
]

app.factory "GigOrder", ["$resource", ($resource) ->
  $resource "api/v1/gigs/:gigId/orders/:id", {id: "@id"}, {get: {method: "GET"}, remove: {method: "DELETE"}, "delete": {method: "DELETE"}, update: {method: "PUT"}}
]

app.factory "GigOrders", ["$resource", ($resource) ->
  $resource "api/v1/gigs/:gigId/orders", {}, {query: {method: "GET", isArray: true}, save: {method: "POST", isArray: false}}
]

app.factory "Seat", ["$resource", ($resource) ->
  $resource "api/v1/seats"
]
