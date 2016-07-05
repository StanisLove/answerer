require 'rails_helper'

RSpec.describe Subscription, type: :model do
  subject { build :subscription }

  it { should belong_to :user }
  it { should belong_to(:subscriber).class_name('User').with_foreign_key('user_id') }
  it { should belong_to :question }

  it { should validate_presence_of :user_id }
  it { should validate_presence_of :question_id }
  it { should validate_uniqueness_of(:user_id).scoped_to(:question_id).case_insensitive }
  it { should have_db_index [:user_id, :question_id] }
end
