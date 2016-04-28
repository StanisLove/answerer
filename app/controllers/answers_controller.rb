class AnswersController < ApplicationController
  before_action :set_answer, only: [:show]
  def index
    @answers = Answer.all
  end

  def new
    @answer = Answer.new
  end

  def show
  end

  private
    
    def set_answer
      @answer = Answer.find(params[:id])
    end

    def answer_params
      params.require(:answer).permit(:body)
    end
end
