class CommentsController < ApplicationController
  before_action :set_commentable, only: [:create]

  def create
    @comment = @commentable.comments
    .new(comment_params.merge(user_id: current_user.id))
    if @comment.save
      PrivatePub.publish_to "/questions/#{@id}/comment",
      comment: render_to_string(template: 'comments/create.json.jbuilder')
    else
      :js
    end
  end

  private

    def comment_params
      params.require(:comment).permit(:body)
    end

    def set_commentable
      if params[:question_id]
        @commentable = Question.find(params[:question_id])
        @id = @commentable.id
      elsif params[:answer_id]
        @commentable = Answer.find(params[:answer_id])
        @id = @commentable.question_id
      end
    end
end
