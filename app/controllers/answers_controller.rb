class AnswersController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :set_answer, only: [:show]
  before_action :load_question, 
    only: [:create, :show, :new, :index, :destroy]

  def index
    @answers = Answer.all
  end

  def new
    @answer = Answer.new
  end

  def show
  end

  def create
    @answer = @question.answers.create(answer_params.merge(user_id: current_user.id))
    flash.now[:notice] = 'Ответ успешно создан'
  end

  def destroy
    @answer = current_user.answers.find(params[:id])
    @answer.destroy
    redirect_to question_answers_path(@question) # надо поменять
  end

  private
    def load_question
      @question = Question.find(params[:question_id])
    end

    def set_answer
      @answer = Answer.find(params[:id])
    end

    def answer_params
      params.require(:answer).permit(:body)
    end
end
