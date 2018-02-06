# Factory to create a tagging.
# It will create spins and tags as needed or be associated to them
FactoryBot.define do
  factory :tagging do
    spin
    tag
  end
end
