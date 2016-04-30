FactoryGirl.define do
  factory :answer do
    body "My String"
    question
  end

  factory :invalid_answer, class: "Answer" do
    body nil
    question
  end
end
