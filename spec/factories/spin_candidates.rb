FactoryBot.define do
  factory :spin_candidate do
    user
    full_name { "#{user.github_login}/#{Faker::App.name.parameterize}" }
    validation_log 'Pending validation'
    published      false
    validated      false
    last_validation nil

    trait :validation_log_full do
      validation_log { Faker::Lorem.sentence }
    end

    trait :published do
      published true

    end
  end
end
