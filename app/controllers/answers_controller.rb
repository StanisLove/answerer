class AnswersController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :load_question, except: [:choose_best]

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
    @answer = @question.answers.create(answer_params.merge(user_id: current_user.id))
    flash.now[:notice] = 'Ответ успешно создан'
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
      params.require(:answer).permit(:body, :is_best)
    end
end
