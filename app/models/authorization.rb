class Authorization < ActiveRecord::Base
  belongs_to :user
  validates :user, :provider, :uid, presence: true
  validates :uid, uniqueness: { scope: :provider }
end
