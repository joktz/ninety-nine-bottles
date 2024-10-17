class Game < ApplicationRecord
  include AASM

  # Define the states of the game
  aasm do
    state :pending, initial: true
    state :ongoing
    state :finished

    # Define the events that can change the state of the game
    event :start do
      transitions from: :pending, to: :ongoing, after: :play_game
    end

    event :finish do
      transitions from: :ongoing, to: :finished
    end

    event :cancel do
      transitions from: [:ongoing, :finished], to: :pending, after: %i[reset_player_scores destroy_rounds]
    end
  end

  # Associations & Validations

  belongs_to :user
  has_many :beers, dependent: :destroy
  has_many :players, dependent: :destroy
  has_many :rounds, dependent: :destroy
  validates :title, presence: true

  # Model methods

  # Determines number of rounds to display in setup round dropdown, from 1 to half the number of beers
  def find_round_range
    (1..(self.beers.count / 2)).to_a
  end

  # Method to control game flow logic
  def play_game
    # Store game's beers in array to track which ones have been used. Takes IDs to avoid extra loading
    beers = self.beers.index_by(&:id)
    remaining_beer_ids = beers.keys.shuffle
    # Assigns a code to each beer for player selection when guessing
    remaining_beer_ids.each_with_index { |beer_id, index| beers[beer_id].update(code: index + 1) }
    build_rounds(remaining_beer_ids.count, remaining_beer_ids)
    play_next_round
  end

  # builds rounds dynamically and assigns beers
  def build_rounds(total_beers, remaining_beer_ids)
    rounds = self.round_count
    beers_per_round = total_beers.to_f / rounds
    if beers_per_round == beers_per_round.to_i
      rounds.times { |round| Round.create(game: self, round_number: round + 1, number_of_beers: beers_per_round.to_i) }
    else
      # Sets numbers of beers per round if number of beers is uneven
      remainder = total_beers - (beers_per_round.floor * (rounds - 1))
      (rounds - 1).times do |round|
        Round.create(game: self, round_number: round + 1, number_of_beers: beers_per_round.floor)
      end
      Round.create(game: self, round_number: rounds, number_of_beers: remainder)
    end
    beers = Beer.where(id: remaining_beer_ids).index_by(&:id)
    selected_beers = []
    self.rounds.each do |round|
      # Selects the beers for the round
      round.number_of_beers.times do
        beer_id = remaining_beer_ids.sample
        beer = beers[beer_id]
        beer.update(round_id: round.id)
        selected_beers << beer
        remaining_beer_ids.delete(beer_id)
      end
    end
  end

  def play_next_round
    # Finds the first round that is pending
    round = self.rounds.find_by(aasm_state: 'pending')
    if round
      # Initializes player answers for the round
      self.players.each do |player|
        round.beers.each do |beer|
          PlayerAnswer.create(player: player, beer: beer, round: round)
        end
      end
      round.start!
    else
      # ends the game, still need to build this logic
      # Needs to open a new page to diplay the winner, needs methods
      self.finish!
    end
  end

  # destroys all rounds on cancellation
  def destroy_rounds
    self.beers.update_all(code: nil, round_id: nil)
    self.rounds.destroy_all
  end

  # resets scores at start or cancellation of game.
  def reset_player_scores
    self.players.each do |player|
      player.update(score: 0)
    end
  end
end
