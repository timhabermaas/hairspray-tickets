app.service "Order", ->
  orders = [
      { id: 1, name: "Peter Mustermann", seats: [2, 4], reduced: 2, full: 4 }
      { id: 2, name: "Dieter Heinzelmann", seats: [], reduced: 2, full: 4 }
    ]

  this.query = ->
    orders

  this.add = (order) ->
    orders.push(order)
