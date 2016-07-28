require 'rails_helper'

RSpec.describe QuestionsController, :auth, type: :controller do
  describe 'GET #index', :unauth do
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
    before { get  :new }

    it 'assigns a new Question to @question' do
      expect(assigns(:question)).to be_a_new(Question)
    end

    it 'renders new view' do
      expect(response).to render_template :new
    end
  end

  describe 'GET #show', :unauth do
    let(:question) { create(:question) }
    before { get :show, id: question }

    it 'assigns the requested question to @question' do
      expect(assigns(:question)).to eq question
    end

    it 'assigns new answer to question' do
      expect(assigns(:answer)).to be_a_new(Answer)
    end

    it 'renders show view' do
      expect(response).to render_template :show
    end
  end

  describe 'POST #create', :valid_attrs do
    subject { post :create, params }

    it 'saves the new question into DB' do
      expect { subject }.to change(user.questions, :count).by(1)
    end

    it 'status is 201' do
      subject
      expect(response.status).to eq 201
    end

    include_examples "publishable", Question

    context 'with invalid attributes', :invalid_attrs do
      include_examples "invalid params", Question
      include_examples "unpublishable", Question

      it 're-renders new view' do
        expect(subject).to render_template :new
      end
    end

    context "Unauthenticated user", :unauth do
      include_examples "invalid params", Question
    end
  end

  describe 'PATCH #update', :updated_attrs do
    let(:question) { create(:question, user: user) }
    let(:params)   { { format: :js, id: question,
                     question: attributes_for(:question).merge(form_params) }
    }

    subject { patch :update, params }

    it 'assigns the request question to @question' do
      subject
      expect(assigns(:question)).to eq question
    end

    it 'changes question attributes' do
      subject
      question.reload
      expect(question.title).to eq 'new title'
      expect(question.body).to  eq 'new body'
    end

    it 'renders update template' do
      expect(subject).to render_template :update
    end

    context "someone's question" do
      let(:question) { create(:question, user: john) }

      it "doesn't change attribures" do
        subject
        question.reload
        expect(question.title).not_to eq 'new title'
        expect(question.body).not_to  eq 'new body'
      end
    end

    context "invalid attributes" do
      let(:form_params) { attributes_for :invalid_question }

      it "doesn't update attributes" do
        expect { subject }.to not_change(question, :body)
          .and not_change(question, :title)
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:question) { create :question, user: user }

    subject { delete :destroy, id: question }

    it 'deletes the question from DB...' do
      expect { subject }.to change(user.questions, :count).by(-1)
    end

    it '...and redirects to index view' do
      expect(subject).to redirect_to questions_path
    end

    context "someone's quesiton" do
      let!(:question) { create :question, user: john }

      include_examples "invalid params", Question

      it "...and redirects to root path" do
        expect(subject).to redirect_to root_path
      end
    end
  end

  describe 'Voting' do
    let(:object) { create(:question) }

    it_behaves_like 'Voted'
  end
end
