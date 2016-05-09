FactoryGirl.define do
  factory :question do
    sequence(:title)  { |n| "Title #{n}" }
    sequence(:body)   { |n| "Body #{n}" }   
    user
  end

  factory :invalid_question, class: "Question" do
    title nil
    body  nil
    user
  end
end
