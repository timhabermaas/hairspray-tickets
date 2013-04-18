5.times do |i|
  Gig.create title: "#{i + 1}. Auftritt", date: DateTime.new(2013, 6, 5 + i)
end
