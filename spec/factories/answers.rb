FactoryGirl.define do
  factory :answer do
    sequence(:body) { |n| "Answer #{n}" }
    question
    user

    after(:create) do |answer|
      create(:attachment, attachable: answer)
    end
  end

  factory :invalid_answer, class: "Answer" do
    body nil
    question
  end

  factory :updated_answer, class: "Answer" do
    body "new body"
    question
  end
end
