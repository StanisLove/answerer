class Authorization < ActiveRecord::Base
  belongs_to :user
  validates  :user, :provider, :uid, presence: true
  validates  :uid, uniqueness: { scope: :provider }, case_sensitive: false

  before_save :set_confirmation_token
  after_save  :send_confirmation,
    unless: Proc.new { |authorization| authorization.confirmed_at? }

  private
    def set_confirmation_token
      self.confirmation_token = Devise.friendly_token
    end

    def send_confirmation
      AuthorizationMailer.send_confirmation(self).deliver_now
      self.update_column(:confirmation_sent_at, Time.now)
    end
end
