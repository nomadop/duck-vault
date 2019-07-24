class Account < ApplicationRecord
  self.inheritance_column = nil

  before_create :init_datetime

  belongs_to :user, optional: true

  scope :active, -> { where(active: true) }
  scope :month_trunc, ->(month) { where("date_trunc('month', timezone('+8', datetime)) = timestamp ?", "#{month}-01") }

  delegate :username, to: :user, allow_nil: true

  enum type: { 吃吃吃: 0, 买买买: 1 }
  enum currency: { cny: 0 }

  private

  def init_datetime
    self.datetime ||= self.created_at
  end
end
