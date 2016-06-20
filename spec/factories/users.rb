FactoryGirl.define do
  factory :user do
    after(:build) { |u| u.skip_confirmation! }

    sequence(:email) { |n| "user_#{n}@mail.com" }
    password '12345678'
    password_confirmation '12345678'
  end

  factory :unauthorized_user, class: "User" do
    sequence(:email) { |n| "user_#{n}@change.me" }
    password '12345678'
    password_confirmation '12345678'
  end
end
