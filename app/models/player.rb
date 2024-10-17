class Player < ApplicationRecord
  belongs_to :game
  has_many :player_answers, dependent: :destroy
  accepts_nested_attributes_for :player_answers

  validates :name, presence: true
  validate :name_uniqueness_check, if: :name_changed?

  private

  # Checks to make sure all the players in that game have a unique name
  def name_uniqueness_check
    if game.players.where(name: name).exists?
      errors.add(:name, "is already taken!")
    end
  end
end
