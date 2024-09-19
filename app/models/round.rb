class Round < ApplicationRecord
  include AASM

  aasm do
    state :pending, initial: true
    state :ongoing
    state :finished

    event :start do
      transitions from: :pending, to: :ongoing
    end

    event :finish do
      transitions from: :ongoing, to: :finished
    end

  end
  belongs_to :game
end
