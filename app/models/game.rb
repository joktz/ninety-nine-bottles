class Game < ApplicationRecord
  include AASM

  # Define the states of the game
  aasm do
    state :pending, initial: true
    state :ongoing
    state :finished

    # Define the events that can change the state of the game
    event :start do
      transitions from: :pending, to: :ongoing, after: %i[reset_player_scores build_rounds]
    end

    event :finish do
      transitions from: :ongoing, to: :finished
    end

    event :cancel do
      transitions from: :ongoing, to: :pending, after: %i[reset_player_scores destroy_rounds]
    end
  end

  belongs_to :user
  has_many :beers, dependent: :destroy
  has_many :players, dependent: :destroy
  has_many :rounds, dependent: :destroy
  validates :title, presence: true

  # Model methods

  # Determines number of rounds to display in the dropdown, from 1 to half the number of beers
  def find_round_range
    (1..(self.beers.count / 2)).to_a
  end

  def reset_player_scores
    self.players.each do |player|
      player.update(score: 0)
    end
  end

  def build_rounds
    self.round_count.times do |round|
      Round.create(game: self, round_number: round + 1)
    end
  end

  def destroy_rounds
    self.rounds.destroy_all
  end
end
