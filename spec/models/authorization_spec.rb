require 'rails_helper'

RSpec.describe Authorization, type: :model do
  subject { build :authorization }

  it { should belong_to            :user }
  it { should have_db_index        [:provider, :uid] }
  it { should validate_presence_of :user }
  it { should validate_presence_of :provider }
  it { should validate_presence_of :uid }
  it { should validate_uniqueness_of(:uid).scoped_to(:provider).case_insensitive }
end
