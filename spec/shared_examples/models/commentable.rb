require 'rails_helper'

shared_examples_for "commentable" do
  let(:model) { create(described_class.to_s.underscore.to_sym) }
  let(:user) { create(:user) }

  context "with #add_comment method" do
    it "user can leave a comment to the #{described_class.to_s.downcase}" do
      model.comments.create({ body: "Body" }.merge(user_id: user.id))
      model.reload
      expect(model.comments.last.body).to eq "Body"
    end

    it "user cannot leave a blank comment" do
      model.comments.create({ body: " " }.merge(user_id: user.id))
      model.reload
      expect(model.comments.any?).to eq false
    end
  end
end
