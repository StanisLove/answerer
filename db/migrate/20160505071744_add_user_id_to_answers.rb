class AddUserIdToAnswers < ActiveRecord::Migration
  def change
    add_belongs_to :answers, :user
    add_index :answers, :user_id
  end
end
