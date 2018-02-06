FactoryBot.define do
  factory :spin_candidate do
    user
    full_name { "#{user.github_login}/#{Faker::App.name.parameterize}" }
    validation_log 'Pending validation'

    trait :validation_log_full do
      validation_log { Faker::Lorem.sentence }
    end
  end
end
