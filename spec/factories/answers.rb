FactoryBot.define do
  factory :answer do
    body { Faker::Number.hexadecimal(10) }
    question

    trait :invalid do
      body { nil }
    end

    factory :answers_list do
      sequence(:body) { |n| "Answer Body #{n} #{Faker::Number.hexadecimal(4)}" }
    end
  end
end
