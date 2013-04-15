app.service "Order", ->
  orders = [
      { id: 1, name: "Peter Mustermann", seats: [2, 4], reduced: 2, paid: false }
      { id: 2, name: "Dieter Heinzelmann", seats: [], reduced: 2, paid: true }
    ]

  this.query = ->
    orders

  this.add = (order) ->
    orders.push(order)
