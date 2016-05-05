class AnswersController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :set_answer, only: [:show]
  before_action :load_question, 
    only: [:create, :show, :new, :index]

  def index
    @answers = Answer.all
  end

  def new
    @answer = Answer.new
  end

  def show
  end

  def create
    @answer = @question.answers.new(answer_params.merge( 
                                   user_id: current_user.id))
    if @answer.save
      redirect_to question_answer_path(@question, @answer),
        notice: 'Ответ успешно создан'
    else
      render :new
    end
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
