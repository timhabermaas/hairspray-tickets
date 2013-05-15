object @order

attributes :id, :name, :reduced_count
node(:paid) { |order| order.paid? }

child :gig do
  attributes :title, :date
end

child :seats do
  attributes :number, :x

  child :row do
    attributes :number, :y # TODO add partial?
  end
end
