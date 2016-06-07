require 'rails_helper'

RSpec.describe CommentsController, type: :controller do

  let(:question)  { create(:question) }
  let(:answer)    { create(:answer, question: question) }

  sign_in_user

  describe 'POST #create' do

    context 'with valid attributes' do
      it "creates question's comment in DB" do
        expect{
          post :create, question_id: question, 
          comment: attributes_for(:comment), format: :js
        }.to change(question.comments, :count).by(1)
      end

      it "creates answer's comment in DB" do
        expect{
          post :create, question_id: question, answer_id: answer, 
          comment: attributes_for(:comment), format: :js
        }.to change(question.comments, :count).by(1)
      end

      it "renders template create" do
        post :create, question_id: question, answer_id: answer, 
        comment: attributes_for(:comment), format: :js
        expect(response).to render_template :create
      end

      it "re-renders new view" do
        post :create, question_id: question, answer_id: answer, 
        comment: attributes_for(:invalid_comment), format: :js
        expect(response).to render_template :create
      end
    end

    context 'with invalid attributes' do
      it " doesn't create question's comment in DB" do
        expect{
          post :create, question_id: question, 
          comment: attributes_for(:invalid_comment), format: :js
        }.to_not change(Comment, :count)
      end

      it "doesn't create answer's comment in DB" do
        expect{
          post :create, question_id: question, answer_id: answer, 
          comment: attributes_for(:invalid_comment), format: :js
        }.to_not change(Comment, :count)
      end
    end

  end
end
