class Player
  attr_reader :name
  attr_accessor :balance, :cards, :score

  def initialize(name)
    @balance = 100
    @name = name
    @cards = []
    @score = 0
  end

  def take_card(user, deck)
    user << deck.cards.delete_at(rand(0..(deck.cards.size - 1)))
    user[-1].value
  end
end
