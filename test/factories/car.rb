FactoryGirl.define do
  factory :car do
    name { Faker::Cat.name }
  end
end