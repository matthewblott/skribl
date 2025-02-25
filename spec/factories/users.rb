FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "user#{n}@example.com" }
    password { 'password12345' }
    password_confirmation { 'password12345' }
    verified { true }

    trait :admin do
      after(:create) do |user|
        user.add_role(:admin)
      end
    end

    factory :admin_user, traits: [:admin]
  end
end
