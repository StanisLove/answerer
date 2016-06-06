require 'rails_helper'

shared_examples_for "commentable" do
  let(:model) { create(described_class.to_s.underscore.to_sym) }
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }

  context "with #add_comment method" do

    it "user can leave a comment to the #{described_class.to_s.downcase}" do
      model.add_comment!({ comments_attributes: { body: "Body" } }, user)
      model.reload
      expect(model.comments.last.body).to eq "Body"
    end

    it "user cannnot leave a comment on someone else's behalf" do
      model.add_comment!(
        { comments_attributes: { body: "Body", user_id: other_user.id } }, user)
      model.reload
      expect(model.comments.where(user: other_user).any?).to eq false 
    end

    it "user cannot leave a blank comment" do
      model.add_comment!({ comments_attributes: { body: " " } }, user)
      model.reload
      expect(model.comments.any?).to eq false 
    end
  end
end
