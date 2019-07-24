FactoryBot.define do
  factory :answer do
    body { Faker::Number.hexadecimal(10) }
    association :question
    association :author, factory: :user

    trait :invalid do
      body { nil }
    end

    trait :with_attachment do
      after :create do |answer|
        file_path = Rails.root.join('public', 'apple-touch-icon.png')
        file = fixture_file_upload(file_path, 'image/png')
        answer.files.attach(file)
      end
    end

    factory :answers_list do
      sequence(:body) { |n| "Answer Body #{n} #{Faker::Number.hexadecimal(4)}" }
    end
  end
end
