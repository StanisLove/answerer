module Concerns::Commented
  extend ActiveSupport::Concern

  included do
    before_action :set_commentable, only: [:add_comment]
  end

  def add_comment
    @commentable.add_comment!(commentable_params, current_user)
    @comment = @commentable.comments.last
  end

  private
    
    def set_commentable
      @commentable = controller_name.classify.constantize.find(params[:id])
    end

    def commentable_params
      send (controller_name.singularize + "_params").to_sym
    end
end
