class QuestionsController < ApplicationController
  include PublicIndexAndShow

  def index
    @questions = Question.all
  end

  def new
    @question = Question.new
    @question.attachments.build
  end

  def show
    @question = Question.find(params[:id])
    @answer = @question.answers.build
    @answer.attachments.build
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

  def vote_up
    @question = Question.find(params[:id])
    @question.vote_up!(current_user)
    if @question.save
      respond_to do |format|
        format.json { render json: @question }
      end
    end
  end

  def vote_down
    @question = Question.find(params[:id])
    @question.vote_down!(current_user)
    if @question.save
      respond_to do |format|
        format.json { render json: @question }
      end
    end
  end

  def vote_reset
    @question = Question.find(params[:id])
    @question.vote_reset!(current_user)
    render json: @question
  end

  private
    def question_params
      params.require(:question).permit(:title, :body, attachments_attributes: [:id, :file, :_destroy])
    end
end
