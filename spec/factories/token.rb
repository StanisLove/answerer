FactoryGirl.define do
  factory :token, class: 'String' do
    skip_create
    Devise.friendly_token
  end
end
