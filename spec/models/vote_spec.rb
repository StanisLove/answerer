require 'rails_helper'

RSpec.describe Vote, type: :model do
  it { should belong_to :votable }
  it { should belong_to :user }

  it { should have_db_index [:votable_type, :votable_id] }
  it { should have_db_index :user_id }

  it { should validate_inclusion_of(:voice).in_array [true, false] }
  it { should validate_presence_of :user_id }
  it { should validate_presence_of :votable_id }
  it { should validate_presence_of :votable_type }
end
