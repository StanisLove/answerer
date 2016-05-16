require 'rails_helper'

RSpec.describe Answer, type: :model do
  it { should belong_to :question }
  it { should have_db_index :question_id }
  it { should belong_to :user }
  it { should have_db_index :user_id }
  it { should have_db_column(:is_best).
              of_type(:boolean).
              with_options(default: false) }

  it { should validate_presence_of :body }
  it { should validate_presence_of :question_id }
  it { should validate_presence_of :user_id }
end
