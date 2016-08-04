class CommentsController < ApplicationController
  before_action :load_commentable,                  only: :create
  before_action :create_new_comment_to_commentable, only: :create
  after_action  :publish_comment,                   only: :create

  authorize_resource

  respond_to :json, :js

  def create
    respond_with @comment
  end

  private

  def comment_params
    params.require(:comment).permit(:body)
  end

  def load_commentable
    name  = request.fullpath.match(%r{\w+(?=\/\d+/comments)}).to_s.singularize
    model = name.capitalize.constantize
    @commentable = model.find(params["#{name}_id".to_sym])
  end

  def create_new_comment_to_commentable
    @comment = @commentable.comments
                           .create(comment_params.merge(user_id: current_user.id))
  end

  def publish_comment
    id = @commentable.try(:question_id) || @commentable.id

    if @comment.valid?
      PrivatePub.publish_to "/questions/#{id}/comment",
                            comment: render_to_string(template: 'comments/create.json.jbuilder')
    end
  end
end
