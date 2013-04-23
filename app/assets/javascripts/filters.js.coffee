app.filter "notPaid", () ->
  (orders) ->
    order for order in orders when order.paid == false

app.filter "all", () ->
  (orders) ->
    orders
