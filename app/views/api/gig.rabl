object @gig

attributes :id, :title, :date

child :prev_gig do
  attributes :id, :title
end

child :next_gig do
  attributes :id, :title
end
