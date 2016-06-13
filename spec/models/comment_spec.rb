require 'rails_helper'

RSpec.describe Comment, type: :model do
  it { should belong_to :user }
  it { should belong_to :commentable }

  it { should have_db_index [:commentable_type, :commentable_id] }
  it { should have_db_index :user_id }

  it { should validate_presence_of :body }
  it { should validate_length_of(:body).is_at_most(1000) }
end
