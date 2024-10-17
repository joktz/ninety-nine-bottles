class PlayerAnswer < ApplicationRecord
  belongs_to :player
  belongs_to :round
  belongs_to :beer
end
