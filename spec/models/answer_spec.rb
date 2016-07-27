require 'rails_helper'

RSpec.describe Answer, type: :model do
  it_behaves_like "attachable"
  it_behaves_like "votable"
  it_behaves_like "commentable"

  it { should belong_to     :question    }
  it { should have_db_index :question_id }
  it { should belong_to     :user        }
  it { should have_db_index :user_id     }
  it do
    should have_db_column(:is_best)
      .of_type(:boolean)
      .with_options(default: false)
  end
  it { should have_many(:attachments).dependent(:destroy) }
  it { should have_many(:comments).dependent(:destroy) }

  it { should validate_presence_of :body }
  it { should validate_presence_of :question_id }
  it { should validate_presence_of :user_id }

  it { should accept_nested_attributes_for :attachments }

  describe "make_best! method" do
    let(:question)   { create(:question) }
    let(:answer_one) { create(:answer, question: question) }
    let(:answer_two) { create(:answer, question: question) }

    it { expect(answer_one.is_best).to      eq false }
    it { expect(answer_two.is_best).to      eq false }

    it "makes answer the best" do
      answer_one.make_best!
      answer_one.reload
      question.reload
      expect(answer_one.is_best).to      eq true
      expect(answer_two.is_best).to      eq false
    end

    it "changes the best answer" do
      answer_one.make_best! && answer_two.make_best!
      answer_one.reload     && answer_two.reload
      expect(answer_one.is_best).to eq false
      expect(answer_two.is_best).to eq true
    end

    it "changes updated_at attribute of answers" do
      answer_one.make_best! && answer_one.reload
      expect do
        answer_two.make_best! && answer_two.reload && answer_one.reload
      end.to change(answer_one, :updated_at)
        .and change(answer_two, :updated_at)
    end
  end
end
