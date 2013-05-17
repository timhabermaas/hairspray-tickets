FactoryGirl.define do
  factory :row do
    number 4
    y 4
  end

  factory :seat do
    number 5
    x 2
    row
    usable true
  end

  factory :gig do
    title "Auftritt #2"
    date DateTime.new(2013, 4, 1)
  end

  factory :order do
    name "Hans Mustermann"
    reduced_count 1
    gig { FactoryGirl.create :gig }
    seats { FactoryGirl.create_list :seat, 2 }

    trait :paid do
      paid_at DateTime.new(2013, 5, 2)
    end

    trait :not_paid do
      paid_at nil
    end

    factory :paid_order, traits: [:paid]
    factory :not_paid_order, traits: [:not_paid]
  end

  factory :account do
    login "hans"
    email "ad@gmail.com"
    password "secret"
  end
end
