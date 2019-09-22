class Leave < ApplicationRecord
  belongs_to :user

  scope :applied, -> { where(status: "applied") }
  scope :accepted, -> { where(status: "accepted") }
  scope :rejected, -> { where(status: "rejected") }
end
