class Game
  attr_reader :bet, :bank
  attr_accessor :player, :dealer

  def initialize(player, dealer)
    @player = player
    @dealer = dealer
    @bet = 10
    @bank = 20
  end

  def show_cards(player)
    player.each.with_index(1) { |card, index| puts "#{index}. #{card.rank}#{card.suit}" }
  end
end
