FactoryBot.define do
  factory :question do
    title { "#{Faker::Number.hexadecimal(4)} question" }
    body { "#{Faker::Number.hexadecimal(10)}. What about it?" }
    association :author, factory: :user

    trait :invalid do
      title { nil }
    end

    # trait :with_file do
    #   files.attach(io: File.open(Rails.root.join('public', 'apple-touch-icon.png')))
    # end

    factory :questions_list do
      sequence(:title) { |n| "Question Title #{n} #{Faker::Number.hexadecimal(2)}" }
      sequence(:body) { |n| "Question Body #{n} #{Faker::Number.hexadecimal(4)}" }
    end
  end
end
