app.filter "germanDate", ["$filter", ($filter) ->
  date = $filter "date"
  (datetime) ->
    return "" unless datetime
    "am #{date(datetime, 'd.MM.yyyy')} um #{date(datetime, 'H:mm')} Uhr"
]

app.filter "seatDescriptions", ->
  # returns "1-3" for [1,2,3]
  # returns "4" for [4]
  seatsToString = (seats) ->
    if seats.length > 1
      "#{seats[0]}-#{seats[seats.length - 1]}"
    else
      "#{seats[0]}"

  # returns [[1,2,3], [5]] when given [1,3,2,5]
  consecutiveSeats = (seats) ->
    seats.sort((a, b) -> a - b)
    result = [[seats[0]]]
    i = 1
    while i < seats.length
      if seats[i] > seats[i - 1] + 1
        result.push([seats[i]])
      else
        result[result.length - 1].push(seats[i])
      i += 1

    result

  (seats) ->
    groupedByRow = _.groupBy(seats, (s) -> s.row.number)
    seatNumbers = ({row: key, seats: consecutiveSeats(s.number for s in value)} for key, value of groupedByRow)
    stringified = ({row: row.row, seats: (seatsToString(seats) for seats in row.seats)} for row in seatNumbers)
    "Reihe #{row.row}, Platz #{row.seats.join(', ')}" for row in stringified

app.filter "normalPriceSum", ->
  (order) ->
    return 0 unless order
    (order.seats.length - order.reduced_count) * 15

app.filter "reducedPriceSum", ->
  (order) ->
    return 0 unless order
    order.reduced_count * 12

app.filter "priceSum", ["$filter", ($filter) ->
  normalPriceSum = $filter "normalPriceSum"
  reducedPriceSum = $filter "reducedPriceSum"
  (order) ->
    return 0 unless order
    normalPriceSum(order) + reducedPriceSum(order)
]
