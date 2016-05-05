class AddUserIdToQuestions < ActiveRecord::Migration
  def change
    add_belongs_to :questions, :user
    add_index :questions, :user_id
  end
end
