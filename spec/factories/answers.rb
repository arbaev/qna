FactoryBot.define do
  factory :answer do
    body { Faker::Movies::Lebowski.quote }
    question

    trait :invalid do
      body { nil }
    end

    factory :answers_list do
      sequence(:body) { |n| "Answer Body #{n}" }
    end
  end
end
