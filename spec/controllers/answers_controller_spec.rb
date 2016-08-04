require 'rails_helper'

RSpec.describe AnswersController, :auth, type: :controller do
  let(:question) { create(:question) }

  describe 'GET #show', :unauth do
    let(:answer) { create :answer, question: question }
    before { get :show, id: answer, question_id: question }

    it 'assigns the requested answer to @answer' do
      expect(assigns(:answer)).to eq answer
    end

    it 'renders show view' do
      expect(response).to render_template :show
    end
  end

  describe 'POST #create', :valid_attrs do
    let(:parent) { { question_id: question } }

    subject { post :create, params }

    it 'saves new answer into DB' do
      expect { subject }.to change(question.answers, :count).by(1)
        .and change(user.answers, :count).by(1)
    end

    it 'renders template create' do
      expect(subject).to render_template :create
    end

    include_examples "publishable", Answer

    context 'with invalid attributes' do
      let(:form_params) { attributes_for :invalid_answer }
      let(:format) { { format: :js } }

      include_examples "invalid params", Answer
      include_examples "unpublishable",  Answer

      it 're-renders new view' do
        expect(subject).to render_template :create
      end
    end
  end

  describe 'DELETE #destroy' do
    subject { delete :destroy, id: answer, format: :js }

    let!(:answer) { create(:answer, user: user) }

    it 'deletes the own answer from DB...' do
      expect { subject }.to change(Answer, :count).by(-1)
    end

    it '...and renders template destroy' do
      expect(subject).to render_template :destroy
    end

    context "someone's answer" do
      let!(:answer) { create :answer, user: john }

      include_examples "invalid params", Answer

      it '... and redirect to root path' do
        expect(subject).to redirect_to root_path
      end
    end

    context 'Not signed in user', :unauth do
      let!(:answer) { create :answer }

      include_examples "invalid params", Answer

      it '...and gets 401' do
        subject
        expect(response.status).to eq 401
      end
    end
  end

  describe 'PATCH #update', :updated_attrs do
    let(:answer) { create(:answer, question: question, user: user) }
    let(:params) { { format: :js, id: answer,
										 answer: attributes_for(:answer).merge(form_params) }
		}

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
      expect(subject).to render_template :update
    end

    context "invalid params" do
      let(:form_params) { attributes_for :invalid_answer }

      it "doesn't update attributes" do
        expect { subject }.not_to change(answer, :body)
      end
    end

    context "someones's answer" do
      let!(:answer) { create :answer, question: question, user: john }

      it "not changes the someone's answer attributes" do
        subject
        answer.reload
        expect(answer.body).not_to eq 'new body'
      end
    end
  end

  describe 'PATCH #choose_best' do
    let(:answer) { create(:answer, question: question) }

    subject { patch :choose_best, id: answer, format: :js }

    context "Unauthenticated user", :unauth do
      it "can't choose the best answer" do
        subject
        expect(answer.is_best).to eq false
      end
    end

    context "Authenticated user" do
      it "can't choose the best answer someone's question" do
        subject
        expect(answer.is_best).to eq false
      end

      context "is the author of the question" do
        let(:question)    { create(:question, user: user) }
        let(:answer)      { create(:answer,   question: question) }
        let(:best_answer) { create(:answer,   question: question, is_best: true) }

        it "can choose the best answer" do
          subject
          answer.reload
          expect(answer.is_best).to eq true
        end

        it "changes the the best answer" do
          expect { subject && answer.reload && best_answer.reload }
            .to  change(answer, :is_best).from(false).to(true)
            .and change(best_answer, :is_best).from(true).to(false)
        end
      end
    end
  end

  describe 'Voting' do
    let(:object) { create(:answer, question: question) }
    it_behaves_like 'Voted'
  end
end
