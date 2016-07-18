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

    it 'renders show view' do
      expect(response).to render_template :show
    end
  end

  describe 'POST #create' do
    sign_in_user
    let(:form_params) { Hash.new }
    let(:format) { Hash[format: :json] }
    let(:params) { Hash[question: attributes_for(:question).merge(form_params)].merge(format) }

    subject { post :create, params }

    context 'with valid attributes' do
      it 'saves the new question into DB' do
        expect{ subject }.to change(@user.questions, :count).by(1)
      end

      it 'status is 201' do
        subject
        expect(response.status).to eq 201
      end

      it 'publishes question to PrivatePub' do
        expect(PrivatePub).to receive(:publish_to)
        subject
      end
    end

    context 'with invalid attributes' do
      let(:form_params) { attributes_for :invalid_question }
      let(:format)      { Hash[format: :html] }

      it 'does not save the new question into DB' do
        expect{ subject }.to_not change(Question, :count)
      end

      it 're-renders new view' do
        subject
        expect(response).to render_template :new
      end

      it ' does not publish question to PrivatePub' do
        expect(PrivatePub).to_not receive(:publish_to)
        subject
      end
    end
  end

  describe 'PATCH #update' do
    sign_in_user
    let(:question)    { create(:question, user: @user) }
    let(:form_params) { Hash[title: 'new title', body: 'new body'] }
    let(:params)      { Hash[format: :js, id: question,
                        question: attributes_for(:question).merge(form_params)] }

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
      subject
      expect(response).to render_template :update
    end

    context "someone's question" do
      let(:question) { create(:question) }

      it "doesn't change attribures" do
        subject
        question.reload
        expect(question.title).to_not eq 'new title'
        expect(question.body).to_not  eq 'new body'
      end
    end

    context "invalid attributes" do
      let(:form_params) { attributes_for :invalid_question }

      it "doesn't update attributes" do
        expect{ subject }.to not_change(question, :body).
                         and not_change(question, :title)
      end
    end

  end

  describe 'DELETE #destroy' do
    sign_in_user
    let!(:question) { create :question, user: @user }

    subject { delete :destroy, id: question }

    it 'deletes the question from DB...' do
      expect{ subject }.to change(@user.questions, :count).by(-1)
    end

    it '...and redirects to index view' do
      subject
      expect(response).to redirect_to questions_path
    end

    context "someone's quesiton" do
      let!(:question) { create :question }

      it "doesn't delete the someone's question from DB..." do
        expect{ subject }.not_to change(Question, :count)
      end

      it "...and redirects to root path" do
        subject
        expect(response).to redirect_to root_path
      end
    end
  end

  describe 'Voting' do
    sign_in_user
    let(:object) { create(:question) }

    it_behaves_like 'Voted'
  end
end
