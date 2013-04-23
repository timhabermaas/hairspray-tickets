collection @seats

attributes :id, :x, :number
child :row do
  attributes :id, :y, :number
end
