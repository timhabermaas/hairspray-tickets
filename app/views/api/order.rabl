object @order

attributes :id, :name, :reduced_count, :paid_at, :created_at, :updated_at
node(:paid) { |order| order.paid? }

child :gig do
  attributes :title, :date
end

child :seats do
  attributes :id, :number, :x

  child :row do
    attributes :number, :y # TODO add partial?
  end
end
