FactoryBot.define do
  factory :answer do
    user
    question
    body { "MyAnswer" }

    trait :invalid do
      body { nil }
    end
  end
end
