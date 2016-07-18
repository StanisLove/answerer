require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:question) { create(:question) }

  describe 'GET #show' do
    let(:answer) { create(:answer) }
    before { get :show, id: answer }

    it 'assigns the requested answer to @answer' do
      expect(assigns(:answer)).to eq answer
    end

    it 'renders show view' do
      expect(response).to render_template :show
    end
  end

  describe 'POST #create' do
    let(:form_params) { Hash.new }
    let(:format)      { Hash[format: :json] }
    let(:params)      { Hash[answer: attributes_for(:answer).merge(form_params),
                        question_id: question].merge(format) }
    subject { post :create, params }
    sign_in_user

    it 'saves new answer into DB' do
      expect{ subject }.to  change(question.answers, :count).by(1)
                       .and change(@user.answers,    :count).by(1)
    end

    it 'renders template create' do
      subject
      expect(response).to render_template :create
    end

    it 'publishes answer to PrivatePub' do
      expect(PrivatePub).to receive(:publish_to)
      subject
    end

    context 'with invalid attributes' do
      let(:form_params) { attributes_for :invalid_answer }
      let(:format)      { Hash[format: :js] }

      it 'does not save the new answer into DB' do
        expect{ subject }.to not_change(Answer, :count)
      end

      it 're-renders new view' do
        subject
        expect(response).to render_template :create
      end

      it 'does not publish answer to PrivatePub' do
        expect(PrivatePub).to_not receive(:publish_to)
        subject
      end
    end
  end

  describe 'DELETE #destroy' do
    subject { delete :destroy, id: answer, format: :js }

    context 'Signed in user' do
      sign_in_user
      let!(:answer) { create(:answer, user_id: @user.id) }

      it 'deletes the own answer from DB...' do
        expect{ subject }.to change(Answer, :count).by(-1)
      end

      it '...and renders template destroy' do
        subject
        expect(response).to render_template :destroy
      end

      context "someone's answer" do
        let!(:answer) { create :answer }

        it "cann't delete from DB..." do
          expect{ subject }.to_not change(Answer, :count)
        end

        it '... and redirect to root path' do
          subject
          expect(response).to redirect_to root_path
        end
      end
    end

    context 'Not signed in user' do
      let!(:answer) { create :answer }

      it "cann't delete someone's answer from DB..." do
        expect{ subject }.to_not change(Answer, :count)
      end

      it '...and gets 401' do
        subject
        expect(response.status).to eq 401
      end
    end
  end

  describe 'PATCH #update' do
    sign_in_user
    let(:answer)      { create(:answer, question: question, user: @user) }
    let(:form_params) { Hash[body: 'new body'] }
    let(:params)      { Hash[format: :js, id: answer,
                             answer: attributes_for(:answer).merge(form_params)] }
    subject { patch :update, params }

    it 'assigns the requested answer to @answer' do
      subject
      expect(assigns(:answer)).to eq answer
    end

    it 'changes the own answer attributes' do
      subject
      answer.reload
      expect(answer.body).to eq 'new body'
    end

    it 'render update template' do
      subject
      expect(response).to render_template :update
    end

    context "invalid params" do
      let(:form_params) { attributes_for :invalid_answer }

      it "doesn't update attributes" do
        expect{ subject }.to_not change(answer, :body)
      end
    end

    context "someones's answer" do
      let!(:answer) { create :answer, question: question }

      it "not changes the someone's answer attributes" do
        subject
        answer.reload
        expect(answer.body).to_not eq 'new body'
      end
    end

  end

  describe 'PATCH #choose_best' do
    let(:answer) { create(:answer, question: question) }

    subject { patch :choose_best, id: answer, format: :js }

    it "user can't choose the best answer" do
      subject
      expect(answer.is_best).to eq false
    end

    context "Authenticated user" do
      sign_in_user

      it "can't choose the best answer someone's question" do
        subject
        expect(answer.is_best).to eq false
      end

      context "is the author of the question" do
        let(:question)    { create(:question, user: @user) }
        let(:answer)      { create(:answer,   question: question) }
        let(:best_answer) { create(:answer,   question: question, is_best: true) }

        it "can choose the best answer" do
          subject
          answer.reload
          expect(answer.is_best).to eq true
        end

        it "changes the the best answer" do
          expect{ subject && answer.reload && best_answer.reload }.
            to  change(answer, :is_best).from(false).to(true).
            and change(best_answer, :is_best).from(true).to(false)
        end
      end
    end
  end

  describe 'Voting' do
    sign_in_user
    let(:object) { create(:answer, question: question) }

    it_behaves_like 'Voted'
  end
end
