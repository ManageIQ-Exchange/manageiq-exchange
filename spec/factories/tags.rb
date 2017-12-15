FactoryBot.define do
  factory :tag do
    name { Faker::StarWars.specie }
  end
end
