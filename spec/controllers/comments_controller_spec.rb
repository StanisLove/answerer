require 'rails_helper'

RSpec.describe CommentsController, type: :controller do

  let(:question)  { create(:question) }
  let(:answer)    { create(:answer, question: question) }

  describe 'POST #create', :auth, :valid_attrs do
    let(:parent) { Hash[question_id: question] }

    subject { post :create, params }

    context 'with valid attributes' do
      it "creates question's comment in DB" do
        expect{ subject }.to change(question.comments, :count).by(1)
      end

      context "for answer" do
        let(:parent) { Hash[answer_id: answer] }

        it "creates comment in DB" do
          expect{ subject }.to change(answer.comments, :count).by(1)
        end
      end

      it "renders template create" do
        subject
        expect(response).to render_template :create
      end

      it "re-renders new view" do
        subject
        expect(response).to render_template :create
      end

      include_examples "publishable"
    end

    context 'with invalid attributes' do
      let(:form_params) { attributes_for :invalid_comment }
      let(:format) { Hash[format: :js] }

      include_examples "invalid params", Comment
      include_examples "unpublishable",  Comment

      context "for answer" do
        let(:parent) { Hash[answer_id: answer] }

        include_examples "invalid params", Comment
        include_examples "unpublishable",  Comment
      end
    end

    context 'Unauthenticated user', :unauth do

      include_examples "invalid params", Comment
      include_examples "unpublishable",  Comment

      context "for answer" do
        let(:parent) { Hash[answer_id: answer] }

        include_examples "invalid params", Comment
        include_examples "unpublishable",  Comment
      end
    end
  end
end
