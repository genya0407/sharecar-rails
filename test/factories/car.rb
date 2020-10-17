FactoryBot.define do
  factory :car do
    name { Faker::Creature::Cat.name }
  end
end
