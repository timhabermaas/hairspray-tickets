object @order

attributes :name

child :gig do
  attributes :title, :date
end

child :seats do
  attributes :number, :x

  child :row do
    attributes :number, :y # TODO add partial?
  end
end