class Beer < ApplicationRecord
  belongs_to :game
  belongs_to :round, optional: true
  has_one_attached :photo
  geocoded_by :origin
  after_validation :geocode, if: :should_geocode?

  validates :name, presence: true
  validates :style, presence: true
  validates :brewery, presence: true
  validates :origin, presence: true

  private

  # Expands geocode parameters
  def should_geocode?
    will_save_change_to_origin? || new_record?
  end
end
