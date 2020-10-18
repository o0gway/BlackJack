class Dealer
  attr_accessor :balance, :cards, :score

  def initialize
    @balance = 100
    @cards = []
    @score = 0
  end
end
