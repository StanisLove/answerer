require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  describe 'GET #index' do
    let(:questions) { create_list(:question, 2) }
    before { get  :index }

    it 'fills the array of questions' do
      expect(assigns(:questions)).to match_array(questions)
    end
      
    it 'renders index view' do
      expect(response).to render_template :index
    end
  end

  describe 'GET #new' do
    sign_in_user
    before { get  :new }

    it 'assigns a new Question to @question' do
      expect(assigns(:question)).to be_a_new(Question)
    end

    it 'build new attachment for question' do
      expect(assigns(:question).attachments.first).to be_a_new(Attachment)
    end

    it 'renders new view' do
      expect(response).to render_template :new
    end
  end

  describe 'GET #show' do
    let(:question) { create(:question) }
    before { get  :show, id: question }

    it 'assigns the requested question to @question' do
      expect(assigns(:question)).to eq question
    end

    it 'assigns new answer to question' do
      expect(assigns(:answer)).to be_a_new(Answer)
    end

    it 'build new attachment for answer' do
      expect(assigns(:answer).attachments.first).to be_a_new(Attachment)
    end

    it 'renders show view' do
      expect(response).to render_template :show
    end
  end

  describe 'POST #create' do
    sign_in_user

    context 'with valid attributes' do
      it 'saves the new question into DB' do
        expect{
          post  :create, question: attributes_for(:question)
        }.to change(@user.questions, :count).by(1)
      end

      it 'redirects to show view' do
        post  :create, question: attributes_for(:question)
        expect(response).to redirect_to question_path(assigns(:question))
      end
    end

    context 'with invalid attributes' do
      it 'does not save the new question into DB' do
        expect{
          post  :create, question: attributes_for(:invalid_question)
        }.to_not change(Question, :count)
      end

      it 're-renders new view' do
        post  :create, question: attributes_for(:invalid_question)
        expect(response).to render_template :new
      end
    end
  end

  describe 'PATCH #update' do
    sign_in_user
    let(:question) { create(:question, user: @user) }
    let(:other_question) { create(:question) }

    it 'assigns the request question to @question' do
      patch :update, id: question, question: attributes_for(:question), format: :js
      expect(assigns(:question)).to eq question
    end

    it 'changes question attributes' do
      patch :update, id: question, question: { title: 'new title', body: 'new body' }, format: :js
      question.reload
      expect(question.title).to eq 'new title'
      expect(question.body).to eq 'new body'
    end

    it "doesn't change someone's question attribures" do
      patch :update, id: other_question, question: { title: 'new title', body: 'new body' }, format: :js
      other_question.reload
      expect(other_question.title).to_not eq 'new title'
      expect(other_question.body).to_not eq 'new body'
    end

    it 'renders update template' do
      patch :update, id: question, question: attributes_for(:question), format: :js
      expect(response).to render_template :update
    end
  end

  describe 'DELETE #destroy' do
    sign_in_user
    let!(:question) { create(:question, user_id: @user.id) }
    let!(:other_question) { create(:question) }

    it 'deletes the question from DB...' do
      expect{
        delete :destroy, id: question
      }.to change(@user.questions, :count).by(-1)
    end

    it '...and redirects to index view' do
      delete :destroy, id: question
      expect(response).to redirect_to questions_path
    end

    it "doesn't delete the someone's question from DB..." do
      expect{
        delete :destroy, id: other_question
      }.not_to change(Question, :count)
    end

    it "...and redirects to root path" do
      delete :destroy, id: other_question
      expect(response).to redirect_to root_path
    end
  end

  describe 'PATCH #vote_up' do
    sign_in_user
    let(:question) { create(:question) }

    it 'assigns the request to @question' do
      patch :vote_up, id: question, format: :json
      expect(assigns(:votable)).to eq question
    end

    it "increase question's votes only once" do
      expect{
        patch :vote_up, id: question,
        format: :json }.to change(question, :voting_result).by(1)

      expect{
        patch :vote_up, id: question,
        format: :json }.to change(question.votes, :count).by(0)
    end
  end

  describe 'PATCH #vote_down' do
    sign_in_user
    let(:question) { create(:question) }

    it 'assigns the request to @votable' do
      patch :vote_down, id: question, format: :json
      expect(assigns(:votable)).to eq question
    end

    it "decrease question's votes only once" do
      expect{
        patch :vote_down, id: question,
        format: :json }.to change(question, :voting_result).by(-1)

      expect{
        patch :vote_down, id: question,
        format: :json }.to change(question.votes, :count).by(0)
    end
  end

  describe 'PATCH #vote_reset' do
    sign_in_user
    let(:question) { create(:question) }
    let!(:vote)  { create(:vote_up, user_id: @user.id, votable: question) }

    it 'assigns the request to @votable' do
      patch :vote_reset, id: question, format: :json
      expect(assigns(:votable)).to eq question
    end

    it "cancel user vote for question" do
      expect(question.voting_result).to eq 1
      expect{
        patch :vote_reset, id: question,
        format: :json }.to change(question, :voting_result).by(-1)
    end
  end
end
