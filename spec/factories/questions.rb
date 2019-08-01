FactoryBot.define do
  factory :question do
    title { "#{Faker::Number.hexadecimal(4)} question" }
    body { "#{Faker::Number.hexadecimal(10)}. What about it?" }
    association :author, factory: :user

    trait :invalid do
      title { nil }
    end

    trait :with_attachment do
      after :create do |question|
        file_path = Rails.root.join('public', 'apple-touch-icon.png')
        file = fixture_file_upload(file_path, 'image/png')
        question.files.attach(file)
      end
    end

    trait :with_reward do
      reward { create(:reward) }
    end

    trait :created_yesterday do
      created_at { Date.yesterday }
      title { "Yesterday question #{Faker::Number.hexadecimal(4)}" }
    end

    trait :created_today do
      created_at { Date.today }
      title { "Today question #{Faker::Number.hexadecimal(4)}" }
    end

    trait :created_xmas do
      created_at { Date.new(2012,12,25) }
      title { "Xmas question #{Faker::Number.hexadecimal(4)}" }
    end

    factory :questions_list do
      sequence(:title) { |n| "Question Title #{n} #{Faker::Number.hexadecimal(2)}" }
      sequence(:body) { |n| "Question Body #{n} #{Faker::Number.hexadecimal(4)}" }
    end
  end
end
