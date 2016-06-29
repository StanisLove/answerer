class Api::V1::AnswersController < Api::V1::BaseController
  before_action :load_question

  authorize_resource

  def index
    @answer = @question.answers.all
    respond_with @question
  end

  def show
    @answer = @question.answers.find(params[:id])
    respond_with @answer, serializer: AnswerPreviewSerializer
  end

  def create
    respond_with current_resource_owner.answers.create(answer_params.merge(question_id: @question.id))
  end

  private
    def load_question
      @question = Question.find(params[:question_id])
    end

    def answer_params
      params.require(:answer).permit(:body)
    end
end
