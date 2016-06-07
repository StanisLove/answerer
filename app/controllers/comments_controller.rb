class CommentsController < ApplicationController
  before_action :set_parent, only: [:create]

  def create
    @comment = @parent.comments.create(comment_params.merge(user_id: current_user.id))
  end

  private

    def comment_params
      params.require(:comment).permit(:body)
    end

    def set_parent
      if params[:question_id]
        @parent = Question.find(params[:question_id])
      elsif params[:answer_id]
        @parent = Answer.find(params[:answer_id])
      end
    end
end
