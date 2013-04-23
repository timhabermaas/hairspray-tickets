Gig.delete_all

5.times do |i|
  Gig.create title: "#{i + 1}. Auftritt", date: DateTime.new(2013, 6, 5 + i)
end

Seat.delete_all
Row.delete_all

16.downto(3) do |i|
  Row.create! y: (i - 16), number: i
end

Row.create! y: 15, number: 2
Row.create! y: 16, number: 1
