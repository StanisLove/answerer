require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let!(:question) { create(:question) }

  describe 'GET #index' do
    let(:answers) { create_list(:answer, 2) }
    before { get  :index, question_id: question }

    it 'fills the array of questons' do
      expect(assigns(:answers)).to match_array(answers)
    end

    it 'renders index view' do
      expect(response).to render_template :index
    end
  end

  describe 'GET #new' do
    sign_in_user
    before { get  :new, question_id: question }

    it 'assigns new Answer to @answer' do
      expect(assigns(:answer)).to be_a_new(Answer)
    end

    it 'renders new view' do
      expect(response).to render_template :new
    end
  end

  describe 'GET #show' do
    let(:answer) { create(:answer) }
    before { get  :show, id: answer, question_id: question }

    it 'assigns the requested answer to @answer' do
      expect(assigns(:answer)).to eq answer
    end

    it 'renders show view' do
      expect(response).to render_template :show
    end
  end

  describe 'POST #create' do
    sign_in_user

    context 'with valid attributes' do
      it 'saves new answer into DB' do
        expect{
          post  :create, question_id: question, answer: attributes_for(:answer), format: :js
        }.to  change(question.answers,  :count).by(1)
              .and change(@user.answers,:count).by(1) 
      end
      
      it 'renders template create' do
        post :create, question_id: question, answer: attributes_for(:answer), format: :js
        expect(response).to render_template :create
      end
    end

    context 'with invalid attributes' do
      it 'does not save the new answer into DB' do
        expect{
          post  :create, question_id: question, answer: attributes_for(:invalid_answer), format: :js
        }.to  not_change(Answer,  :count)
      end

      it 're-renders new view' do
        post  :create, question_id: question, answer: attributes_for(:invalid_answer), format: :js
        expect(response).to render_template :create
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:other_answer) { create(:answer) }

    context 'Signed in user' do
      sign_in_user
      let!(:answer) { create(:answer, user_id: @user.id) }
      
      it 'deletes the own answer from DB...' do
        expect{
          delete :destroy, id: answer, question_id: question, format: :js
        }.to change(Answer, :count).by(-1)
      end

      it '...and renders template destroy' do
        delete :destroy, id: answer, question_id: question, format: :js
        expect(response).to render_template :destroy
      end

      it "not deletes someone's answer from DB..." do
        expect{
          delete :destroy, id: other_answer, question_id: question, format: :js
        }.to_not change(Answer, :count) 
      end
      
      it '... and redirect to root path' do
        delete :destroy, id: other_answer, question_id: question, format: :js
        expect(response).to redirect_to root_path
      end
    end

      

    context 'Not signed in user' do
      it "not deletes someone's answer from DB..." do
        expect{
          delete :destroy, id: other_answer, question_id: question, format: :js
        }.to_not change(Answer, :count) 
      end
      
      it '...and gets 401' do
        delete :destroy, id: other_answer, question_id: question, format: :js
        expect(response.status).to eq 401 
      end
    end
  end

  describe 'PATCH #update' do
    sign_in_user
    let(:answer) { create(:answer, question: question, user: @user) }
    let(:other_answer) { create(:answer, question: question) }

    it 'assigns the requested answer to @answer' do
      patch :update, id: answer, question_id: question, answer: attributes_for(:answer), format: :js
      expect(assigns(:answer)).to eq answer
    end

    it 'changes the own answer attributes' do
      patch :update, id: answer, question_id: question, answer: { body: 'new body' }, format: :js
      answer.reload
      expect(answer.body).to eq 'new body'
    end

    it "not changes the someone's answer attributes" do
      patch :update, id: other_answer, question_id: question, answer: { body: 'new body' }, format: :js
      other_answer.reload
      expect(other_answer.body).to_not eq 'new body'
    end

    it 'render update template' do
      patch :update, id: answer, question_id: question, answer: attributes_for(:answer), format: :js
      expect(response).to render_template :update
    end
  end

  describe 'PATCH #choose_best' do
    let!(:answer) { create(:answer, question: question) }

    it "user can't choose the best answer" do
      patch :choose_best, id: answer, question_id: question, answer: { is_best: true }, format: :js
      expect(answer.is_best).to eq false
    end

    context "Authenticated user" do
      sign_in_user
      let!(:own_question)   { create(:question, user: @user) }
      let!(:some_answer_one){ create(:answer, question: own_question) }
      let!(:some_answer_two){ create(:answer, question: own_question) }

      it "can't choose the best answer" do
        patch :choose_best, id: answer, question_id: question, format: :js
        expect(answer.is_best).to eq false
      end

      it %q{is the author of the question and 
            can choose the best answer and
            the best answer is only one
      } do
        expect(some_answer_one.is_best).to eq false
        expect(some_answer_two.is_best).to eq false

        patch :choose_best, id: some_answer_one, question_id: own_question, format: :js
        some_answer_one.reload

        expect(some_answer_one.is_best).to eq true
        expect(some_answer_two.is_best).to eq false

        patch :choose_best, id: some_answer_two, question_id: own_question, format: :js

        expect(assigns(:question)).to eq own_question
        expect(assigns(:answer)).to   eq some_answer_two

        some_answer_two.reload
        expect(some_answer_two.is_best).to eq true
        some_answer_one.reload
        expect(some_answer_one.is_best).to eq false
      end
    end
  end

  describe 'PATCH #vote_up' do
    sign_in_user
    let(:answer) { create(:answer, question: question) }

    it 'assigns the request to @answer' do
      patch :vote_up, id: answer, question_id: question, format: :json
      expect(assigns(:votable)).to eq answer
    end

    it "increase answer's votes only once" do
      expect{
        patch :vote_up, id: answer, question_id: question,
        format: :json }.to change(answer, :voting_result).by(1)

      expect{
        patch :vote_up, id: answer, question_id: question,
        format: :json }.to change(answer.votes, :count).by(0)
    end
  end
  
  describe 'PATCH #vote_down' do
    sign_in_user
    let(:answer) { create(:answer, question: question) }

    it 'assigns the request to @answer' do
      patch :vote_down, id: answer, question_id: question, format: :json
      expect(assigns(:votable)).to eq answer
    end

    it "decrease answer's votes only once" do
      expect{
        patch :vote_down, id: answer, question_id: question,
        format: :json }.to change(answer, :voting_result).by(-1)

      expect{
        patch :vote_down, id: answer, question_id: question,
        format: :json }.to change(answer.votes, :count).by(0)
    end
  end

  describe 'PATCH #vote_reset' do
    sign_in_user
    let(:answer) { create(:answer, question: question) }
    let!(:vote)  { create(:vote_up, user_id: @user.id, votable: answer) }

    it 'assigns the request to @answer' do
      patch :vote_reset, id: answer, question_id: question, format: :json
      expect(assigns(:votable)).to eq answer
    end

    it "cancel user vote for answer" do
      expect(answer.voting_result).to eq 1
      expect{
        patch :vote_reset, id: answer, question_id: question,
        format: :json }.to change(answer, :voting_result).by(-1)
    end
  end
end
