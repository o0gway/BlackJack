class Player
  attr_reader :name
  attr_accessor :balance, :cards, :score

  def initialize(name)
    @balance = 100
    @name = name
    @cards = []
    @score = 0
  end

  # def validate!

  # end
end
