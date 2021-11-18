class Developer < ApplicationRecord
  include Availability

  enum search_status: {
    actively_looking: 1,
    open: 2,
    not_interested: 3
  }

  belongs_to :user
  has_one :role_type, dependent: :destroy, autosave: true
  has_one_attached :avatar
  has_one_attached :cover_image

  accepts_nested_attributes_for :role_type

  validates :name, presence: true
  validates :hero, presence: true
  validates :bio, presence: true
  validates :avatar, content_type: ["image/png", "image/jpg", "image/jpeg"],
    max_file_size: 2.megabytes
  validates :cover_image, content_type: ["image/png", "image/jpg", "image/jpeg", "image/gif"],
    max_file_size: 10.megabytes

  scope :available, -> { where("available_on <= ?", Date.today) }
  scope :most_recently_added, -> { order(created_at: :desc) }

  after_initialize :build_role_type, if: -> { role_type.blank? }
  monetize :expected_salary_cents, allow_nil: true
  monetize :expected_hourly_rate_cents, allow_nil: true
end
