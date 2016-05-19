require 'rails_helper'

RSpec.describe Attachment, type: :model do
  it { should belong_to :question }
  it { should have_db_index :question_id }
end
