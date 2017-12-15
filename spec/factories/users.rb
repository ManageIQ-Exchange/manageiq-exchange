FactoryBot.define do

  factory :user do
    id                { (@gh = Faker::Omniauth.github)[:uid] }
    name              { @gh[:info][:name] }
    admin             false
    staff             false
    karma             0
    github_avatar_url { @gh[:extra][:raw_info][:avatar_url] || ''}
    github_html_url   { @gh[:extra][:raw_info][:html_url] }
    github_id         { @gh[:uid]} #Faker::Omniauth.github[:uid] }
    github_login      { @gh[:info][:nickname] }
    github_company    { @gh[:extra][:raw_info][:company] || '' }
    github_type       { @gh[:extra][:raw_info][:type] }
    github_blog       { @gh[:extra][:raw_info][:blog] || ''}
    github_location   { @gh[:extra][:raw_info][:location] || 'Madrid(Spain)'}
    github_bio        { @gh[:extra][:raw_info][:bio] || '' }
    github_created_at { @gh[:extra][:raw_info][:created_at]}
    github_updated_at { @gh[:extra][:raw_info][:updated_at] }
    email             { @gh[:info][:email] }
    sign_in_count     0
  end
end
