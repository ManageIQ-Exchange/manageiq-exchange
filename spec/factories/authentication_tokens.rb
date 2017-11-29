FactoryBot.define do
  factory :authentication_token do
    body "MyString"
    user nil
    last_used_at "2017-11-29 14:32:14"
    ip_address "MyString"
    user_agent "MyString"
  end
end
