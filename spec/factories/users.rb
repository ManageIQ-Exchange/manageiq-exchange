FactoryBot.define do
  factory :user do

    name              'John'
    github_avatar_url 'https://avatars2.githubusercontent.com/u/3019213?v=4'
    github_html_url   'https://github.com/john'
    github_id         '3019213'
    github_login      'john'
    github_company    ''
    github_type       'User'
    github_blog       ''
    github_location   'Madrid, Spain'
    sign_in_count     0
    email             'john@john.com'
    github_bio        'The BIO of John'
    github_created_at 2.months.ago
    github_updated_at 1.hour.ago
  end
end
