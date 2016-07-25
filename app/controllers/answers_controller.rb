class AnswersController < ApplicationController
  include PublicIndexAndShow
  include Voted

  before_action :load_question,                 only: [:index, :show, :new, :create]
  before_action :create_new_answer_to_question, only: :create
  before_action :load_answer,                   only: [:show, :choose_best]
  before_action :load_current_user_answer,      only: [:update, :destroy]
  after_action  :publish_answer,                only: :create

  authorize_resource

  respond_to  :json, :js, only: [:create, :update, :destroy]

  def show
    respond_with @answer
  end

  def create
    respond_with @answer
  end

  def update
    @answer.update(answer_params)
    respond_with @answer
  end

  def destroy
    respond_with @answer.destroy
  end

  def choose_best
    @question = @answer.question
    @answer.make_best! if current_user.id == @question.user_id
  end

  private
    def answer_params
      params.require(:answer).permit(:body, :is_best,
        attachments_attributes: [:id, :file, :_destroy])
    end

    def load_question
      @question = Question.find(params[:question_id])
    end

    def load_answer
      @answer = Answer.find(params[:id])
    end

    def load_current_user_answer
      @answer = current_user.answers.find(params[:id])
    end

    def publish_answer
      PrivatePub.publish_to "/questions/#{@question.id}/answer",
      answer: render_to_string(template: 'answers/create.json.jbuilder') if @answer.valid?
    end

    def create_new_answer_to_question
      @answer = @question.answers.create(answer_params.merge(user_id: current_user.id))
    end
end
