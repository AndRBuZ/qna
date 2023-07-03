FactoryBot.define do
  factory :comment do
    commentable { nil }
    user
    body { 'Test Comment' }
  end
end
