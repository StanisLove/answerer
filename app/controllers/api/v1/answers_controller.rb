class Api::V1::AnswersController < Api::V1::BaseController
  before_action :load_question

  def index
    @answer = @question.answers.all
    respond_with @question
  end

  def show
    @answer = @question.answers.find(params[:id])
    respond_with @answer, serializer: AnswerPreviewSerializer
  end

  private
    def load_question
      @question = Question.find(params[:question_id])
    end
end
