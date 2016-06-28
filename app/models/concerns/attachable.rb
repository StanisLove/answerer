module Concerns::Attachable
  extend ActiveSupport::Concern

  included do
    has_many  :attachments, as: :attachable, dependent: :destroy

    accepts_nested_attributes_for :attachments,
                                  allow_destroy: true,
                                  reject_if: proc { |a| a['file'].blank? }
  end
end
