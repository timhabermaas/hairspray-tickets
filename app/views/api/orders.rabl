collection @orders

if authorized?(:user, :admin)
  attributes :id, :name, :reduced_count, :paid_at, :created_at, :updated_at
else
  attributes :id
end

node(:paid) { |o| o.paid? }

child :seats => :seats do
  attributes :id, :number, :x
  child :row do
    attributes :number, :y
  end
end
