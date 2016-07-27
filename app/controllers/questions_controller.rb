class QuestionsController < ApplicationController
  include PublicIndexAndShow
  include Voted

  before_action :load_question,                         only: :show
  before_action :build_answer_and_load_current_user_id, only: :show
  before_action :set_subscription,                      only: :show
  before_action :load_current_user_question, only: [:update, :destroy]
  after_action  :publish_question, only: :create

  authorize_resource

  respond_to :json, only: :create
  respond_to :js,   only: :update

  def index
    respond_with(@questions = Question.all)
  end

  def new
    respond_with(@question = Question.new)
  end

  def show
    respond_with @question
  end

  def create
    respond_with(@question = current_user.questions.create(question_params))
  end

  def update
    @question.update(question_params)
    respond_with @question
  end

  def destroy
    respond_with(@question.destroy)
  end

  private

  def question_params
    params.require(:question).permit(:title, :body,
                                     attachments_attributes: [:id, :file, :_destroy])
  end

  def publish_question
    PrivatePub.publish_to '/questions', question: @question.to_json if @question.valid?
  end

  def load_question
    @question = Question.find(params[:id])
  end

  def load_current_user_question
    @question = current_user.questions.find(params[:id])
  end

  def build_answer_and_load_current_user_id
    @answer = @question.answers.build
    gon.current_user_id = current_user.try(:id)
  end

  def set_subscription
    @subscription = Subscription.find_by(user: current_user,
                                         question: @question)

    @subscription ||= Subscription.new(user: current_user,
                                       question: @question)
  end
end
