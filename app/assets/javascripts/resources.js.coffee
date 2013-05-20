commonParameters = [{id: "@id"}, {update: {method: "PUT"}}]

app.factory "Gig", ["$resource", ($resource) ->
  $resource "api/v1/gigs/:id", commonParameters...
]

app.factory "GigOrder", ["$resource", ($resource) ->
  $resource "api/v1/gigs/:gigId/orders/:id/:action", {id: "@id"}, {update: {method: "PUT"}, pay: {method: "POST", params: {action: "pay"}}, unpay: {method: "POST", params: {action: "unpay"}}}
]

app.factory "Seat", ["$resource", ($resource) ->
  $resource "api/v1/seats", commonParameters...
]

app.factory "Account", ["$resource", ($resource) ->
  $resource "api/v1/accounts", commonParameters...
]

app.factory "SessionResource", ["$resource", ($resource) ->
  $resource "api/v1/sessions", commonParameters...
]
