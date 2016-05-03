FactoryGirl.define do
  factory :question do
    sequence(:title)  { |n| "Title #{n}" }
    sequence(:body)   { |n| "Body #{n}" }   
  end

  factory :invalid_question, class: "Question" do
    title nil
    body  nil
  end
end
