class SearchController < ApplicationController
  skip_before_action :authenticate_user!
  before_action      :load_results

  authorize_resource class: false

  def index
    respond_with @results
  end

  private

  def load_results
    klass_model = params[:model] == 'Anywhere' ?
                                ThinkingSphinx : params[:model].classify.constantize

    @results = klass_model.search(ThinkingSphinx::Query.escape(params[:query]))
  end
end
