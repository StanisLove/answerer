FactoryGirl.define do
  factory :comment do
    sequence(:body) { |n| "Comment #{n}" }
    user
    association :commentable
  end

  factory :invalid_comment, class: "Comment" do
    body nil
    user
    association :commentable
  end

  factory :updated_comment, class: "Comment" do
    body "new body"
    user
    association :commentable
  end
end
