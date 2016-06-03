class CreateVotes < ActiveRecord::Migration
  def change
    create_table :votes do |t|
      t.boolean :voice, null: false
      t.integer :user_id, index: true
      t.references :votable, polymorphic: true, index: true
      t.timestamps null: false
    end
  end
end
