Gig.delete_all

5.times do |i|
  Gig.create title: "#{i + 1}. Auftritt", date: DateTime.new(2013, 6, 5 + i)
end

Seat.delete_all
Row.delete_all

16.downto(3) do |i|
  Row.create! y: (-i + 16), number: i
end

Row.create! y: 15, number: 2
Row.create! y: 16, number: 1

first_row = Row.where(:number => 1).first
second_row = Row.where(:number => 2).first

18.times do |i|
  Seat.create! x: 15 + i, number: 1 + i, row: first_row
end
12.times do |i|
  Seat.create! x: 36 + i, number: 19 + i, row: first_row
end

24.times do |i|
  Seat.create! x: 9 + i, number: 1 + i, row: second_row
end
12.times do |i|
  Seat.create! x: 36 + i, number: 25 + i, row: second_row
end


middle_rows = Row.where(:number => 3..13)
middle_rows.each do |row|
  30.times do |i|
    # left side
    Seat.create! x: 3 + i, number: 1 + i, row: row
  end
  18.times do |i|
    # right side
    Seat.create! x: 36 + i, number: 31 + i, row: row
  end
end

upper_rows = Row.where(:number => 14..15)
upper_rows.each do |row|
  # left side
  18.times do |i|
    Seat.create! x: 3 + i, number: 1 + i, row: row
  end

  # right side
  18.times do |i|
    Seat.create x: 36 + i, number: 19 + i, row: row
  end
end

highest_row = Row.where(:number => 16).first

21.times do |i|
  Seat.create x: i, number: 1 + i, row: highest_row
  Seat.create x: 33 + i, number: 22 + i, row: highest_row
end
