FactoryGirl.define do
  factory :attachment do
    file do 
      File.open(File.join(Rails.root, '/spec/spec_helper.rb'))
    end

    association :attachable
  end
end
