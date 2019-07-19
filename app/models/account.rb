class Account < ApplicationRecord
  self.inheritance_column = nil

  before_create :init_datetime

  belongs_to :user, optional: true

  scope :active, -> { where(active: true) }

  enum type: { 吃吃吃: 0, 买买买: 1 }
  enum currency: { cny: 0 }

  private
  def init_datetime
    self.datetime ||= self.created_at
  end
end
