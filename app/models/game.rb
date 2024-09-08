class Game < ApplicationRecord
  belongs_to :user
  has_many :beers, dependent: :destroy
  has_many :players, dependent: :destroy
end
