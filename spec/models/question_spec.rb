require 'rails_helper'

RSpec.describe Question, type: :model do
  it { should have_many :answers }

  it { should validate_presence_of  :title }
  it { should validate_presence_of  :body }
  it { should validate_length_of(:title).is_at_most(140) }
end
