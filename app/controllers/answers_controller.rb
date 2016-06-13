class AnswersController < ApplicationController
  include PublicIndexAndShow
  include Voted

  before_action :load_question, except: [:choose_best]#, only: [:index, :new, :create, :update, :destroy]

  def index
    @answers = Answer.all
  end

  def new
    @answer = Answer.new
  end

  def show
    @answer = Answer.find(params[:id])
  end

  def create
    @answer = @question.answers.new(answer_params.merge(user_id: current_user.id))
    if @answer.save
      PrivatePub.publish_to "/questions/#{@question.id}/answer",
        answer: render_to_string(template: 'answers/create.json.jbuilder')
      flash.now[:notice] = 'Ответ успешно создан'
    else
      :js
    end
  end

  def update
    @answer = current_user.answers.find(params[:id])
    @answer.update(answer_params)
  end

  def destroy
    @answer = current_user.answers.find(params[:id])
    @answer.destroy
  end

  def choose_best
    @question = current_user.questions.find(params[:question_id])
    @answer = @question.answers.find(params[:id])
    @answer.make_best!
  end

  private
    def load_question
      @question = Question.find(params[:question_id])
    end

    def answer_params
      params.require(:answer).permit(:body, :is_best,
        attachments_attributes: [:id, :file, :_destroy])
    end
end
