FactoryBot.define do
  factory :tag do
    sequence :name do |n|
       "#{Faker::StarWars.specie}_#{n}"
    end
  end
end
