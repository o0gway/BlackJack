class Player
  attr_reader :name
  attr_accessor :balance

  def initialize(name)
    @balance = 100
    @name = name
  end
end
