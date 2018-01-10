FactoryBot.define do
  factory :spin do
    id                { Faker::Number.number(10) }
    published         false
    visible           false
    user
    name              { Faker::App.name.parameterize }
    full_name         { "#{user.github_login}/#{name}" }
    description       { Faker::Lorem.sentence }
    clone_url         { Faker::Internet.url }
    forks_count       { Faker::Number.between(0, 10) }
    stargazers_count  { Faker::Number.between(0, 10) }
    watchers_count    { Faker::Number.between(0, 10) }
    open_issues_count { Faker::Number.between(0, 10) }
    size              { Faker::Number.between(0, 10) }
    gh_id             { id }
    gh_created_at     { Faker::Time.backward(100) }
    gh_pushed_at      { Faker::Time.between(gh_created_at, Date.today) }
    gh_updated_at     { Faker::Time.between(gh_created_at, Date.today) }
    gh_archived       false
    default_branch    'master'
    log               ''
    license_key       "MIT"
    license_name      "MIT License"
    license_html_url  "https://api.github.com/licenses/mit"
    version           { "0.#{Faker::Number.between(0,10)}.#{Faker::Number.between(0,10)}" }  # Should be Faker::App.semantic_version when it works
    metadata          do
      { "tags":[], "author": user.name, "company": nil, "license": license_key, "dependencies": nil, "spin_version": version, "min_miq_version"=>"h"}.to_json
    end
    min_miq_version   { Faker::Number.between(5, 9) }
    first_import      { Faker::Time.between(gh_created_at, Date.today) }
    score             0
    company           { Faker::Company.name }
    readme            { Faker::Lorem.sentence }

    trait :published do
      published true
    end

  end
end
