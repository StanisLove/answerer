FactoryGirl.define do
  factory :authorization do
    provider 'twitter'
    uid '123456'
    confirmed_at nil
    user
  end
end
