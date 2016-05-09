require 'rails_helper'

RSpec.describe Question, type: :model do
  it { should have_many(:answers).dependent(:destroy) }
  it { should belong_to :user }
  it { should have_db_index :user_id }
  it { should validate_presence_of  :title }
  it { should validate_presence_of  :body }
  it { should validate_length_of(:title).is_at_most(140) }
  it { should validate_presence_of  :user_id }
end
