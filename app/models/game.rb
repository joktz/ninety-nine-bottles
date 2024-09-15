class Game < ApplicationRecord
  include AASM

  # Define the states of the game
  aasm do
    state :pending, initial: true
    state :ongoing
    state :finished
    state :canceled

    # Define the events that can change the state of the game
    event :start do
      transitions from: :pending, to: :ongoing
    end

    event :finish do
      transitions from: :ongoing, to: :finished
    end

    event :cancel do
      transitions from: %i[pending ongoing], to: :canceled
    end
  end

  belongs_to :user
  has_many :beers, dependent: :destroy
  has_many :players, dependent: :destroy
  enum status: { pending: 0, ongoing: 1, finished: 2, canceled: 3 }
  validates :title, presence: true
end
