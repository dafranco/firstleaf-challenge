# This will guess the User class
FactoryBot.define do
  factory :user, class:"User" do
    email { Faker::Internet.email }
    key { Faker::Alphanumeric.alpha(number: 100) }
    account_key { Faker::Alphanumeric.alpha(number: 100) }
    phone_number { Faker::PhoneNumber.phone_number }
    password { Faker::Internet.password }
  end
end