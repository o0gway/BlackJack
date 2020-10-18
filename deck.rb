class Deck
  attr_accessor :cards

  @@rank = %w[2 3 4 5 6 7 8 9 10 V D K T]
  @@suit = %w[♥ ♣ ♦ ♠]
  @@value = [2, 3, 4, 5, 6, 7, 8, 9, 10, 10, 10, 10, 11]

  def initialize
    @cards = []
    @@suit.each do |suit|
      @@rank.each do |rank|
        value = @@value.shift
        @cards << Card.new(suit, rank, value)
      end
    @@value = [2, 3, 4, 5, 6, 7, 8, 9, 10, 10, 10, 10, 11]
    end
  end
end
