class Vote < ActiveRecord::Base
  belongs_to :user
  belongs_to :votable, polymorphic: true

  validates  :voice, :user_id, :votable_id, :votable_type, presence: true
end
