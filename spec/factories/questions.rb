FactoryGirl.define do
  factory :question do
    sequence(:title)  { |n| "Title #{n}" }
    sequence(:body)   { |n| "Body #{n}" }
    user

    after(:create) do |question|
      create(:attachment, attachable: question)
    end
  end

  factory :invalid_question, class: "Question" do
    title nil
    body  nil
    user
  end
end
