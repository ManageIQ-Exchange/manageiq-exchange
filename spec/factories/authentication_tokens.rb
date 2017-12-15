FactoryBot.define do
  factory :authentication_token do
    body { Faker::Crypto.md5 }
    user
    last_used_at { Faker::Time.between(DateTime.now - 2.years, DateTime.now) }
    ip_address { Faker::Internet.ip_v4_address }
    user_agent { Faker::Internet.user_agent }
    github_token { Faker::Crypto.md5 }
  end
end
