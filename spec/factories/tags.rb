# Factory for tags
# Creates an object with a random name

FactoryBot.define do
  factory :tag do
    sequence :name do |n|
      "#{Faker::StarWars.specie}_#{n}"
    end
  end
end
