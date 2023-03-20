FactoryBot.define do
  sequence :title do |n|
    "title_#{n}"
  end

  factory :question do
    user
    title
    body { "MyQuestion" }

    trait :invalid do
      title { nil }
    end
  end
end
