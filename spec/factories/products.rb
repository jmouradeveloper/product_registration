FactoryBot.define do
  factory :product do
    name      { Faker::Commerce.product_name }
    price     { Faker::Commerce.price }
    photo_url { Faker::Internet.url }
  end
end
