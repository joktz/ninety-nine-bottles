class Beer < ApplicationRecord
  belongs_to :game
  has_one_attached :photo
  geocoded_by :origin
  after_validation :geocode, if: :will_save_change_to_origin?

  validates :name, presence: true
  validates :style, presence: true
  validates :brewery, presence: true
end
