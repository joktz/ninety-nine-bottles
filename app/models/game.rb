class Game < ApplicationRecord
  belongs_to :user
  has_many :beers
  has_many :players, dependent: :destroy
end
