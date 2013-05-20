object @gig

attributes :id, :title, :date

child @gig.prev_gig => :prev_gig do
  attributes :id, :title
end

child @gig.next_gig => :next_gig do
  attributes :id, :title
end
