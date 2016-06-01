FactoryGirl.define do
  factory :vote_up, class: "Vote" do
    voice true    
    user
    association :votable
  end
  
  factory :vote_down, class: "Vote" do
    voice false    
    user
    association :votable
  end
end
