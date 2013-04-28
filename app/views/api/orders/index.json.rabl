collection @orders

attributes :id, :name, :reduced_count
node(:paid) { |order| order.paid? }

child :seats => :seats do
  attributes :id, :number, :x
  child :row do
    attributes :number, :y
  end
end
