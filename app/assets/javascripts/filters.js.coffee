app.filter "notPaid", ->
  (orders) ->
    order for order in orders when order.paid == false

app.filter "all", ->
  (orders) ->
    orders

app.filter "limit", ->
  (array, limit) ->
    if array then array[0..limit-1] else []

app.filter "seatDescription", ->
  (seat) ->
    "Reihe #{seat.row.number}, Platz #{seat.number}"

app.filter "normalPriceSum", ->
  (order) ->
    return 0 unless order
    (order.seats.length - order.reduced_count) * 15

app.filter "reducedPriceSum", ->
  (order) ->
    return 0 unless order
    order.reduced_count * 12

app.filter "priceSum", ["$filter", ($filter) ->
  normalPriceSum = $filter("normalPriceSum")
  reducedPriceSum = $filter("reducedPriceSum")
  (order) ->
    return 0 unless order
    normalPriceSum(order) + reducedPriceSum(order)
]
