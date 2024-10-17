class Round < ApplicationRecord
  include AASM

  # State machine
  aasm do
    state :pending, initial: true
    state :ongoing
    state :finished

    event :start do
      transitions from: :pending, to: :ongoing
    end

    event :finish do
      transitions from: :ongoing, to: :finished, after: :end_round
    end
  end

  # Associations and validations
  belongs_to :game
  has_many :beers
  has_many :player_answers, dependent: :destroy

  # Round methods

  # Ends the round and calculates the scores

  # Pseudocode
  # 1. Get all the player answers for the round
  # 2. Use beer id for each answer to compare player_answer code to beer code
  # 3. If the answer is correct, increment the player's scoree by 100

  def end_round
    self.player_answers.each do |answer|
      beer = Beer.find(answer.beer_id)
      if beer.code == answer.answer
        player = Player.find(answer.player_id)
        player.score += 100
        player.save
      end
    end
  end
end
