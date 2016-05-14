class QuestionsController < ApplicationController
  before_action :authenticate_user!, 
    only: [:new, :create, :destroy, :update]

  def index
    @questions = Question.all
  end

  def new
    @question = Question.new
  end

  def show
    @question = Question.find(params[:id])
    @answer = @question.answers.build
  end

  def create
    @question = current_user.questions.new(question_params)
    if @question.save
      redirect_to @question, notice: 'Вопрос успешно создан'
    else
      render  :new
    end
  end

  def update
    @question = current_user.questions.find(params[:id])
    @question.update(question_params)
  end

  def destroy
    @question = current_user.questions.find(params[:id])
    @question.destroy
    redirect_to questions_path
  end

  private

    def question_params
      params.require(:question).permit(:title, :body)
    end
end
