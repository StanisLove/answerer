class AddQuestionIdToAnswer < ActiveRecord::Migration
  def change
    add_belongs_to :answers, :question
  end
end
