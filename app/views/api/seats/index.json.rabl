collection @seats

attributes :id, :x, :number, :usable
child :row do
  attributes :y, :number
end
