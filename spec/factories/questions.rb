FactoryBot.define do
  factory :question do
    title { "#{Faker::Coffee.blend_name} question" }
    body { "Coffe from #{Faker::Coffee.origin}. What does it tase like?" }
    author { :user }

    trait :invalid do
      title { nil }
    end

    factory :questions_list do
      sequence(:title) { |n| "Question Title #{n}" }
      sequence(:body) { |n| "Question Body #{n}" }
    end
  end
end
