FactoryGirl.define do
  factory :vote_up, class: "Vote" do
    voice 1
    user
    association :votable
  end

  factory :vote_down, class: "Vote" do
    voice -1
    user
    association :votable
  end
end
