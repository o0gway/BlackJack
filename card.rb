class Card
  attr_reader :rank, :suit, :value

  def initialize(suit, rank, value)
    @rank = rank
    @suit = suit
    @value = value
  end
end
